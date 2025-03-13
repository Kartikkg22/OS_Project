
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
80100028:	bc d0 54 18 80       	mov    $0x801854d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 31 10 80       	mov    $0x80103120,%eax
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
8010004c:	68 c0 73 10 80       	push   $0x801073c0
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 45 44 00 00       	call   801044a0 <initlock>
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
80100092:	68 c7 73 10 80       	push   $0x801073c7
80100097:	50                   	push   %eax
80100098:	e8 d3 42 00 00       	call   80104370 <initsleeplock>
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
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

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
801000e4:	e8 a7 45 00 00       	call   80104690 <acquire>
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
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
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
80100162:	e8 c9 44 00 00       	call   80104630 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 42 00 00       	call   801043b0 <acquiresleep>
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
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
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
801001a1:	68 ce 73 10 80       	push   $0x801073ce
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

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
801001be:	e8 8d 42 00 00       	call   80104450 <holdingsleep>
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
801001d4:	e9 f7 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 df 73 10 80       	push   $0x801073df
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

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
801001ff:	e8 4c 42 00 00       	call   80104450 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 fc 41 00 00       	call   80104410 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 70 44 00 00       	call   80104690 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 c2 43 00 00       	jmp    80104630 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 e6 73 10 80       	push   $0x801073e6
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

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
80100294:	e8 e7 15 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801002a0:	e8 eb 43 00 00       	call   80104690 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002b5:	39 05 04 ef 10 80    	cmp    %eax,0x8010ef04
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
801002cd:	e8 3e 3e 00 00       	call   80104110 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 69 37 00 00       	call   80103a50 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ef 10 80       	push   $0x8010ef20
801002f6:	e8 35 43 00 00       	call   80104630 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 9c 14 00 00       	call   801017a0 <ilock>
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
8010034c:	e8 df 42 00 00       	call   80104630 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 46 14 00 00       	call   801017a0 <ilock>
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
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
80100399:	e8 22 26 00 00       	call   801029c0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 ed 73 10 80       	push   $0x801073ed
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 7d 78 10 80 	movl   $0x8010787d,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 f3 40 00 00       	call   801044c0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 01 74 10 80       	push   $0x80107401
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 fc 5a 00 00       	call   80105f20 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 31 5a 00 00       	call   80105f20 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 25 5a 00 00       	call   80105f20 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 19 5a 00 00       	call   80105f20 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ba 42 00 00       	call   80104820 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 15 42 00 00       	call   80104790 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 05 74 10 80       	push   $0x80107405
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 bc 12 00 00       	call   80101880 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005cb:	e8 c0 40 00 00       	call   80104690 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 20 ef 10 80       	push   $0x8010ef20
80100604:	e8 27 40 00 00       	call   80104630 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 8e 11 00 00       	call   801017a0 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 d0 78 10 80 	movzbl -0x7fef8730(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 54 ef 10 80    	mov    0x8010ef54,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ef 10 80       	push   $0x8010ef20
801007d8:	e8 b3 3e 00 00       	call   80104690 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 20 ef 10 80       	push   $0x8010ef20
801007fb:	e8 30 3e 00 00       	call   80104630 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 18 74 10 80       	mov    $0x80107418,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 1f 74 10 80       	push   $0x8010741f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 20 ef 10 80       	push   $0x8010ef20
801008b3:	e8 d8 3d 00 00       	call   80104690 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 22                	js     801008e5 <consoleintr+0x45>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 47                	je     8010090f <consoleintr+0x6f>
801008c8:	7f 76                	jg     80100940 <consoleintr+0xa0>
801008ca:	83 fb 08             	cmp    $0x8,%ebx
801008cd:	74 76                	je     80100945 <consoleintr+0xa5>
801008cf:	83 fb 10             	cmp    $0x10,%ebx
801008d2:	0f 85 f8 00 00 00    	jne    801009d0 <consoleintr+0x130>
  while((c = getc()) >= 0){
801008d8:	ff d6                	call   *%esi
    switch(c){
801008da:	bf 01 00 00 00       	mov    $0x1,%edi
  while((c = getc()) >= 0){
801008df:	89 c3                	mov    %eax,%ebx
801008e1:	85 c0                	test   %eax,%eax
801008e3:	79 de                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008e5:	83 ec 0c             	sub    $0xc,%esp
801008e8:	68 20 ef 10 80       	push   $0x8010ef20
801008ed:	e8 3e 3d 00 00       	call   80104630 <release>
  if(doprocdump) {
801008f2:	83 c4 10             	add    $0x10,%esp
801008f5:	85 ff                	test   %edi,%edi
801008f7:	0f 85 4b 01 00 00    	jne    80100a48 <consoleintr+0x1a8>
}
801008fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100900:	5b                   	pop    %ebx
80100901:	5e                   	pop    %esi
80100902:	5f                   	pop    %edi
80100903:	5d                   	pop    %ebp
80100904:	c3                   	ret
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 f1 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
8010090f:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100914:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
8010091a:	74 9f                	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010091c:	83 e8 01             	sub    $0x1,%eax
8010091f:	89 c2                	mov    %eax,%edx
80100921:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100924:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
8010092b:	74 8e                	je     801008bb <consoleintr+0x1b>
  if(panicked){
8010092d:	8b 15 58 ef 10 80    	mov    0x8010ef58,%edx
        input.e--;
80100933:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
80100938:	85 d2                	test   %edx,%edx
8010093a:	74 c9                	je     80100905 <consoleintr+0x65>
8010093c:	fa                   	cli
    for(;;)
8010093d:	eb fe                	jmp    8010093d <consoleintr+0x9d>
8010093f:	90                   	nop
    switch(c){
80100940:	83 fb 7f             	cmp    $0x7f,%ebx
80100943:	75 2b                	jne    80100970 <consoleintr+0xd0>
      if(input.e != input.w){
80100945:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
8010094a:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100950:	0f 84 65 ff ff ff    	je     801008bb <consoleintr+0x1b>
        input.e--;
80100956:	83 e8 01             	sub    $0x1,%eax
80100959:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
  if(panicked){
8010095e:	a1 58 ef 10 80       	mov    0x8010ef58,%eax
80100963:	85 c0                	test   %eax,%eax
80100965:	0f 84 ce 00 00 00    	je     80100a39 <consoleintr+0x199>
8010096b:	fa                   	cli
    for(;;)
8010096c:	eb fe                	jmp    8010096c <consoleintr+0xcc>
8010096e:	66 90                	xchg   %ax,%ax
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100970:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100975:	89 c2                	mov    %eax,%edx
80100977:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
8010097d:	83 fa 7f             	cmp    $0x7f,%edx
80100980:	0f 87 35 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100986:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010098c:	8d 50 01             	lea    0x1(%eax),%edx
8010098f:	83 e0 7f             	and    $0x7f,%eax
80100992:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100998:	88 98 80 ee 10 80    	mov    %bl,-0x7fef1180(%eax)
  if(panicked){
8010099e:	85 c9                	test   %ecx,%ecx
801009a0:	0f 85 ae 00 00 00    	jne    80100a54 <consoleintr+0x1b4>
801009a6:	89 d8                	mov    %ebx,%eax
801009a8:	e8 53 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009ad:	83 fb 0a             	cmp    $0xa,%ebx
801009b0:	74 68                	je     80100a1a <consoleintr+0x17a>
801009b2:	83 fb 04             	cmp    $0x4,%ebx
801009b5:	74 63                	je     80100a1a <consoleintr+0x17a>
801009b7:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801009bc:	83 e8 80             	sub    $0xffffff80,%eax
801009bf:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801009c5:	0f 85 f0 fe ff ff    	jne    801008bb <consoleintr+0x1b>
801009cb:	eb 52                	jmp    80100a1f <consoleintr+0x17f>
801009cd:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009d0:	85 db                	test   %ebx,%ebx
801009d2:	0f 84 e3 fe ff ff    	je     801008bb <consoleintr+0x1b>
801009d8:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801009dd:	89 c2                	mov    %eax,%edx
801009df:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
801009e5:	83 fa 7f             	cmp    $0x7f,%edx
801009e8:	0f 87 cd fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ee:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
801009f1:	8b 0d 58 ef 10 80    	mov    0x8010ef58,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
801009f7:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801009fa:	83 fb 0d             	cmp    $0xd,%ebx
801009fd:	75 93                	jne    80100992 <consoleintr+0xf2>
        input.buf[input.e++ % INPUT_BUF] = c;
801009ff:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
80100a05:	c6 80 80 ee 10 80 0a 	movb   $0xa,-0x7fef1180(%eax)
  if(panicked){
80100a0c:	85 c9                	test   %ecx,%ecx
80100a0e:	75 44                	jne    80100a54 <consoleintr+0x1b4>
80100a10:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a15:	e8 e6 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a1a:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
          wakeup(&input.r);
80100a1f:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a22:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
80100a27:	68 00 ef 10 80       	push   $0x8010ef00
80100a2c:	e8 9f 37 00 00       	call   801041d0 <wakeup>
80100a31:	83 c4 10             	add    $0x10,%esp
80100a34:	e9 82 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a39:	b8 00 01 00 00       	mov    $0x100,%eax
80100a3e:	e8 bd f9 ff ff       	call   80100400 <consputc.part.0>
80100a43:	e9 73 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
}
80100a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a4b:	5b                   	pop    %ebx
80100a4c:	5e                   	pop    %esi
80100a4d:	5f                   	pop    %edi
80100a4e:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a4f:	e9 5c 38 00 00       	jmp    801042b0 <procdump>
80100a54:	fa                   	cli
    for(;;)
80100a55:	eb fe                	jmp    80100a55 <consoleintr+0x1b5>
80100a57:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100a5e:	00 
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 28 74 10 80       	push   $0x80107428
80100a6b:	68 20 ef 10 80       	push   $0x8010ef20
80100a70:	e8 2b 3a 00 00       	call   801044a0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c f9 10 80 b0 	movl   $0x801005b0,0x8010f90c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 f9 10 80 80 	movl   $0x80100280,0x8010f908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 c2 19 00 00       	call   80102460 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave
80100aa2:	c3                   	ret
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	57                   	push   %edi
80100ab4:	56                   	push   %esi
80100ab5:	53                   	push   %ebx
80100ab6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100abc:	e8 8f 2f 00 00       	call   80103a50 <myproc>
80100ac1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100ac7:	e8 64 23 00 00       	call   80102e30 <begin_op>

  if((ip = namei(path)) == 0){
80100acc:	83 ec 0c             	sub    $0xc,%esp
80100acf:	ff 75 08             	push   0x8(%ebp)
80100ad2:	e8 a9 15 00 00       	call   80102080 <namei>
80100ad7:	83 c4 10             	add    $0x10,%esp
80100ada:	85 c0                	test   %eax,%eax
80100adc:	0f 84 30 03 00 00    	je     80100e12 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ae2:	83 ec 0c             	sub    $0xc,%esp
80100ae5:	89 c7                	mov    %eax,%edi
80100ae7:	50                   	push   %eax
80100ae8:	e8 b3 0c 00 00       	call   801017a0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100aed:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100af3:	6a 34                	push   $0x34
80100af5:	6a 00                	push   $0x0
80100af7:	50                   	push   %eax
80100af8:	57                   	push   %edi
80100af9:	e8 b2 0f 00 00       	call   80101ab0 <readi>
80100afe:	83 c4 20             	add    $0x20,%esp
80100b01:	83 f8 34             	cmp    $0x34,%eax
80100b04:	0f 85 01 01 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b0a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b11:	45 4c 46 
80100b14:	0f 85 f1 00 00 00    	jne    80100c0b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b1a:	e8 71 65 00 00       	call   80107090 <setupkvm>
80100b1f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b25:	85 c0                	test   %eax,%eax
80100b27:	0f 84 de 00 00 00    	je     80100c0b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b34:	00 
80100b35:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b3b:	0f 84 a1 02 00 00    	je     80100de2 <exec+0x332>
  sz = 0;
80100b41:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b48:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4b:	31 db                	xor    %ebx,%ebx
80100b4d:	e9 8c 00 00 00       	jmp    80100bde <exec+0x12e>
80100b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100b58:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b5f:	75 6c                	jne    80100bcd <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100b61:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b67:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b6d:	0f 82 87 00 00 00    	jb     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b73:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b79:	72 7f                	jb     80100bfa <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b7b:	83 ec 04             	sub    $0x4,%esp
80100b7e:	50                   	push   %eax
80100b7f:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100b85:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100b8b:	e8 30 63 00 00       	call   80106ec0 <allocuvm>
80100b90:	83 c4 10             	add    $0x10,%esp
80100b93:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b99:	85 c0                	test   %eax,%eax
80100b9b:	74 5d                	je     80100bfa <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b9d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ba3:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba8:	75 50                	jne    80100bfa <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100baa:	83 ec 0c             	sub    $0xc,%esp
80100bad:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100bb3:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100bb9:	57                   	push   %edi
80100bba:	50                   	push   %eax
80100bbb:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bc1:	e8 2a 62 00 00       	call   80106df0 <loaduvm>
80100bc6:	83 c4 20             	add    $0x20,%esp
80100bc9:	85 c0                	test   %eax,%eax
80100bcb:	78 2d                	js     80100bfa <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bcd:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bd4:	83 c3 01             	add    $0x1,%ebx
80100bd7:	83 c6 20             	add    $0x20,%esi
80100bda:	39 d8                	cmp    %ebx,%eax
80100bdc:	7e 52                	jle    80100c30 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bde:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100be4:	6a 20                	push   $0x20
80100be6:	56                   	push   %esi
80100be7:	50                   	push   %eax
80100be8:	57                   	push   %edi
80100be9:	e8 c2 0e 00 00       	call   80101ab0 <readi>
80100bee:	83 c4 10             	add    $0x10,%esp
80100bf1:	83 f8 20             	cmp    $0x20,%eax
80100bf4:	0f 84 5e ff ff ff    	je     80100b58 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100bfa:	83 ec 0c             	sub    $0xc,%esp
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 08 64 00 00       	call   80107010 <freevm>
  if(ip){
80100c08:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	57                   	push   %edi
80100c0f:	e8 1c 0e 00 00       	call   80101a30 <iunlockput>
    end_op();
80100c14:	e8 87 22 00 00       	call   80102ea0 <end_op>
80100c19:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c24:	5b                   	pop    %ebx
80100c25:	5e                   	pop    %esi
80100c26:	5f                   	pop    %edi
80100c27:	5d                   	pop    %ebp
80100c28:	c3                   	ret
80100c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100c30:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c36:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c3c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c42:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100c48:	83 ec 0c             	sub    $0xc,%esp
80100c4b:	57                   	push   %edi
80100c4c:	e8 df 0d 00 00       	call   80101a30 <iunlockput>
  end_op();
80100c51:	e8 4a 22 00 00       	call   80102ea0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c56:	83 c4 0c             	add    $0xc,%esp
80100c59:	53                   	push   %ebx
80100c5a:	56                   	push   %esi
80100c5b:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c61:	56                   	push   %esi
80100c62:	e8 59 62 00 00       	call   80106ec0 <allocuvm>
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	89 c7                	mov    %eax,%edi
80100c6c:	85 c0                	test   %eax,%eax
80100c6e:	0f 84 86 00 00 00    	je     80100cfa <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c74:	83 ec 08             	sub    $0x8,%esp
80100c77:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100c7d:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c7f:	50                   	push   %eax
80100c80:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100c81:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c83:	e8 a8 64 00 00       	call   80107130 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c88:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c8b:	83 c4 10             	add    $0x10,%esp
80100c8e:	8b 10                	mov    (%eax),%edx
80100c90:	85 d2                	test   %edx,%edx
80100c92:	0f 84 56 01 00 00    	je     80100dee <exec+0x33e>
80100c98:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100c9e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100ca1:	eb 23                	jmp    80100cc6 <exec+0x216>
80100ca3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ca8:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100cab:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100cb2:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100cb8:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100cbb:	85 d2                	test   %edx,%edx
80100cbd:	74 51                	je     80100d10 <exec+0x260>
    if(argc >= MAXARG)
80100cbf:	83 f8 20             	cmp    $0x20,%eax
80100cc2:	74 36                	je     80100cfa <exec+0x24a>
80100cc4:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc6:	83 ec 0c             	sub    $0xc,%esp
80100cc9:	52                   	push   %edx
80100cca:	e8 b1 3c 00 00       	call   80104980 <strlen>
80100ccf:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd1:	58                   	pop    %eax
80100cd2:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd5:	83 eb 01             	sub    $0x1,%ebx
80100cd8:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cdb:	e8 a0 3c 00 00       	call   80104980 <strlen>
80100ce0:	83 c0 01             	add    $0x1,%eax
80100ce3:	50                   	push   %eax
80100ce4:	ff 34 b7             	push   (%edi,%esi,4)
80100ce7:	53                   	push   %ebx
80100ce8:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100cee:	e8 fd 65 00 00       	call   801072f0 <copyout>
80100cf3:	83 c4 20             	add    $0x20,%esp
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	79 ae                	jns    80100ca8 <exec+0x1f8>
    freevm(pgdir);
80100cfa:	83 ec 0c             	sub    $0xc,%esp
80100cfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d03:	e8 08 63 00 00       	call   80107010 <freevm>
80100d08:	83 c4 10             	add    $0x10,%esp
80100d0b:	e9 0c ff ff ff       	jmp    80100c1c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d10:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d17:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d1d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d23:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d26:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d29:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100d30:	00 00 00 00 
  ustack[1] = argc;
80100d34:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100d3a:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d41:	ff ff ff 
  ustack[1] = argc;
80100d44:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4a:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100d4c:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4e:	29 d0                	sub    %edx,%eax
80100d50:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d56:	56                   	push   %esi
80100d57:	51                   	push   %ecx
80100d58:	53                   	push   %ebx
80100d59:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5f:	e8 8c 65 00 00       	call   801072f0 <copyout>
80100d64:	83 c4 10             	add    $0x10,%esp
80100d67:	85 c0                	test   %eax,%eax
80100d69:	78 8f                	js     80100cfa <exec+0x24a>
  for(last=s=path; *s; s++)
80100d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80100d6e:	8b 55 08             	mov    0x8(%ebp),%edx
80100d71:	0f b6 00             	movzbl (%eax),%eax
80100d74:	84 c0                	test   %al,%al
80100d76:	74 17                	je     80100d8f <exec+0x2df>
80100d78:	89 d1                	mov    %edx,%ecx
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100d80:	83 c1 01             	add    $0x1,%ecx
80100d83:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d85:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100d88:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d8b:	84 c0                	test   %al,%al
80100d8d:	75 f1                	jne    80100d80 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	6a 10                	push   $0x10
80100d94:	52                   	push   %edx
80100d95:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100d9b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100d9e:	50                   	push   %eax
80100d9f:	e8 9c 3b 00 00       	call   80104940 <safestrcpy>
  curproc->pgdir = pgdir;
80100da4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100daa:	89 f0                	mov    %esi,%eax
80100dac:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100daf:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100db1:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100db4:	89 c1                	mov    %eax,%ecx
80100db6:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dbc:	8b 40 18             	mov    0x18(%eax),%eax
80100dbf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dc2:	8b 41 18             	mov    0x18(%ecx),%eax
80100dc5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dc8:	89 0c 24             	mov    %ecx,(%esp)
80100dcb:	e8 90 5e 00 00       	call   80106c60 <switchuvm>
  freevm(oldpgdir);
80100dd0:	89 34 24             	mov    %esi,(%esp)
80100dd3:	e8 38 62 00 00       	call   80107010 <freevm>
  return 0;
80100dd8:	83 c4 10             	add    $0x10,%esp
80100ddb:	31 c0                	xor    %eax,%eax
80100ddd:	e9 3f fe ff ff       	jmp    80100c21 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de2:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100de7:	31 f6                	xor    %esi,%esi
80100de9:	e9 5a fe ff ff       	jmp    80100c48 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100dee:	be 10 00 00 00       	mov    $0x10,%esi
80100df3:	ba 04 00 00 00       	mov    $0x4,%edx
80100df8:	b8 03 00 00 00       	mov    $0x3,%eax
80100dfd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e04:	00 00 00 
80100e07:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e0d:	e9 17 ff ff ff       	jmp    80100d29 <exec+0x279>
    end_op();
80100e12:	e8 89 20 00 00       	call   80102ea0 <end_op>
    cprintf("exec: fail\n");
80100e17:	83 ec 0c             	sub    $0xc,%esp
80100e1a:	68 30 74 10 80       	push   $0x80107430
80100e1f:	e8 8c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e24:	83 c4 10             	add    $0x10,%esp
80100e27:	e9 f0 fd ff ff       	jmp    80100c1c <exec+0x16c>
80100e2c:	66 90                	xchg   %ax,%ax
80100e2e:	66 90                	xchg   %ax,%ax

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 3c 74 10 80       	push   $0x8010743c
80100e3b:	68 60 ef 10 80       	push   $0x8010ef60
80100e40:	e8 5b 36 00 00       	call   801044a0 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave
80100e49:	c3                   	ret
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e5c:	68 60 ef 10 80       	push   $0x8010ef60
80100e61:	e8 2a 38 00 00       	call   80104690 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 60 ef 10 80       	push   $0x8010ef60
80100e91:	e8 9a 37 00 00       	call   80104630 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave
80100e9f:	c3                   	ret
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 60 ef 10 80       	push   $0x8010ef60
80100eaa:	e8 81 37 00 00       	call   80104630 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave
80100eb8:	c3                   	ret
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 60 ef 10 80       	push   $0x8010ef60
80100ecf:	e8 bc 37 00 00       	call   80104690 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 60 ef 10 80       	push   $0x8010ef60
80100eec:	e8 3f 37 00 00       	call   80104630 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave
80100ef7:	c3                   	ret
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 43 74 10 80       	push   $0x80107443
80100f00:	e8 7b f4 ff ff       	call   80100380 <panic>
80100f05:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f0c:	00 
80100f0d:	8d 76 00             	lea    0x0(%esi),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 60 ef 10 80       	push   $0x8010ef60
80100f21:	e8 6a 37 00 00       	call   80104690 <acquire>
  if(f->ref < 1)
80100f26:	8b 53 04             	mov    0x4(%ebx),%edx
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 d2                	test   %edx,%edx
80100f2e:	0f 8e a5 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 ea 01             	sub    $0x1,%edx
80100f37:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3a:	75 44                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f3c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f40:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f43:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4b:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f4e:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f51:	8b 43 10             	mov    0x10(%ebx),%eax
80100f54:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f57:	68 60 ef 10 80       	push   $0x8010ef60
80100f5c:	e8 cf 36 00 00       	call   80104630 <release>

  if(ff.type == FD_PIPE)
80100f61:	83 c4 10             	add    $0x10,%esp
80100f64:	83 ff 01             	cmp    $0x1,%edi
80100f67:	74 57                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f69:	83 ff 02             	cmp    $0x2,%edi
80100f6c:	74 2a                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f71:	5b                   	pop    %ebx
80100f72:	5e                   	pop    %esi
80100f73:	5f                   	pop    %edi
80100f74:	5d                   	pop    %ebp
80100f75:	c3                   	ret
80100f76:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7d:	00 
80100f7e:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100f80:	c7 45 08 60 ef 10 80 	movl   $0x8010ef60,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 9d 36 00 00       	jmp    80104630 <release>
80100f93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80100f98:	e8 93 1e 00 00       	call   80102e30 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	push   -0x20(%ebp)
80100fa3:	e8 28 09 00 00       	call   801018d0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 e9 1e 00 00       	jmp    80102ea0 <end_op>
80100fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fbe:	00 
80100fbf:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 22 26 00 00       	call   801035f0 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 4b 74 10 80       	push   $0x8010744b
80100fe1:	e8 9a f3 ff ff       	call   80100380 <panic>
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	53                   	push   %ebx
80100ff4:	83 ec 04             	sub    $0x4,%esp
80100ff7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ffd:	75 31                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80100fff:	83 ec 0c             	sub    $0xc,%esp
80101002:	ff 73 10             	push   0x10(%ebx)
80101005:	e8 96 07 00 00       	call   801017a0 <ilock>
    stati(f->ip, st);
8010100a:	58                   	pop    %eax
8010100b:	5a                   	pop    %edx
8010100c:	ff 75 0c             	push   0xc(%ebp)
8010100f:	ff 73 10             	push   0x10(%ebx)
80101012:	e8 69 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
80101017:	59                   	pop    %ecx
80101018:	ff 73 10             	push   0x10(%ebx)
8010101b:	e8 60 08 00 00       	call   80101880 <iunlock>
    return 0;
  }
  return -1;
}
80101020:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101023:	83 c4 10             	add    $0x10,%esp
80101026:	31 c0                	xor    %eax,%eax
}
80101028:	c9                   	leave
80101029:	c3                   	ret
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave
80101039:	c3                   	ret
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	55                   	push   %ebp
80101041:	89 e5                	mov    %esp,%ebp
80101043:	57                   	push   %edi
80101044:	56                   	push   %esi
80101045:	53                   	push   %ebx
80101046:	83 ec 0c             	sub    $0xc,%esp
80101049:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010104c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010104f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101052:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101056:	74 60                	je     801010b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101058:	8b 03                	mov    (%ebx),%eax
8010105a:	83 f8 01             	cmp    $0x1,%eax
8010105d:	74 41                	je     801010a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105f:	83 f8 02             	cmp    $0x2,%eax
80101062:	75 5b                	jne    801010bf <fileread+0x7f>
    ilock(f->ip);
80101064:	83 ec 0c             	sub    $0xc,%esp
80101067:	ff 73 10             	push   0x10(%ebx)
8010106a:	e8 31 07 00 00       	call   801017a0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010106f:	57                   	push   %edi
80101070:	ff 73 14             	push   0x14(%ebx)
80101073:	56                   	push   %esi
80101074:	ff 73 10             	push   0x10(%ebx)
80101077:	e8 34 0a 00 00       	call   80101ab0 <readi>
8010107c:	83 c4 20             	add    $0x20,%esp
8010107f:	89 c6                	mov    %eax,%esi
80101081:	85 c0                	test   %eax,%eax
80101083:	7e 03                	jle    80101088 <fileread+0x48>
      f->off += r;
80101085:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101088:	83 ec 0c             	sub    $0xc,%esp
8010108b:	ff 73 10             	push   0x10(%ebx)
8010108e:	e8 ed 07 00 00       	call   80101880 <iunlock>
    return r;
80101093:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	89 f0                	mov    %esi,%eax
8010109b:	5b                   	pop    %ebx
8010109c:	5e                   	pop    %esi
8010109d:	5f                   	pop    %edi
8010109e:	5d                   	pop    %ebp
8010109f:	c3                   	ret
    return piperead(f->pipe, addr, n);
801010a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801010a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a9:	5b                   	pop    %ebx
801010aa:	5e                   	pop    %esi
801010ab:	5f                   	pop    %edi
801010ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010ad:	e9 fe 26 00 00       	jmp    801037b0 <piperead>
801010b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010bd:	eb d7                	jmp    80101096 <fileread+0x56>
  panic("fileread");
801010bf:	83 ec 0c             	sub    $0xc,%esp
801010c2:	68 55 74 10 80       	push   $0x80107455
801010c7:	e8 b4 f2 ff ff       	call   80100380 <panic>
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
801010d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801010dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010e5:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
801010e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010ec:	0f 84 bb 00 00 00    	je     801011ad <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010f2:	8b 03                	mov    (%ebx),%eax
801010f4:	83 f8 01             	cmp    $0x1,%eax
801010f7:	0f 84 bf 00 00 00    	je     801011bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010fd:	83 f8 02             	cmp    $0x2,%eax
80101100:	0f 85 c8 00 00 00    	jne    801011ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101109:	31 f6                	xor    %esi,%esi
    while(i < n){
8010110b:	85 c0                	test   %eax,%eax
8010110d:	7f 30                	jg     8010113f <filewrite+0x6f>
8010110f:	e9 94 00 00 00       	jmp    801011a8 <filewrite+0xd8>
80101114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101118:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010111b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010111e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101121:	ff 73 10             	push   0x10(%ebx)
80101124:	e8 57 07 00 00       	call   80101880 <iunlock>
      end_op();
80101129:	e8 72 1d 00 00       	call   80102ea0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101131:	83 c4 10             	add    $0x10,%esp
80101134:	39 c7                	cmp    %eax,%edi
80101136:	75 5c                	jne    80101194 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
80101138:	01 fe                	add    %edi,%esi
    while(i < n){
8010113a:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010113d:	7e 69                	jle    801011a8 <filewrite+0xd8>
      int n1 = n - i;
8010113f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
80101142:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
80101147:	29 f7                	sub    %esi,%edi
      if(n1 > max)
80101149:	39 c7                	cmp    %eax,%edi
8010114b:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
8010114e:	e8 dd 1c 00 00       	call   80102e30 <begin_op>
      ilock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 73 10             	push   0x10(%ebx)
80101159:	e8 42 06 00 00       	call   801017a0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010115e:	57                   	push   %edi
8010115f:	ff 73 14             	push   0x14(%ebx)
80101162:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101165:	01 f0                	add    %esi,%eax
80101167:	50                   	push   %eax
80101168:	ff 73 10             	push   0x10(%ebx)
8010116b:	e8 40 0a 00 00       	call   80101bb0 <writei>
80101170:	83 c4 20             	add    $0x20,%esp
80101173:	85 c0                	test   %eax,%eax
80101175:	7f a1                	jg     80101118 <filewrite+0x48>
80101177:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010117a:	83 ec 0c             	sub    $0xc,%esp
8010117d:	ff 73 10             	push   0x10(%ebx)
80101180:	e8 fb 06 00 00       	call   80101880 <iunlock>
      end_op();
80101185:	e8 16 1d 00 00       	call   80102ea0 <end_op>
      if(r < 0)
8010118a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010118d:	83 c4 10             	add    $0x10,%esp
80101190:	85 c0                	test   %eax,%eax
80101192:	75 14                	jne    801011a8 <filewrite+0xd8>
        panic("short filewrite");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 5e 74 10 80       	push   $0x8010745e
8010119c:	e8 df f1 ff ff       	call   80100380 <panic>
801011a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
801011a8:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ab:	74 05                	je     801011b2 <filewrite+0xe2>
801011ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
801011b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b5:	89 f0                	mov    %esi,%eax
801011b7:	5b                   	pop    %ebx
801011b8:	5e                   	pop    %esi
801011b9:	5f                   	pop    %edi
801011ba:	5d                   	pop    %ebp
801011bb:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
801011bc:	8b 43 0c             	mov    0xc(%ebx),%eax
801011bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011c5:	5b                   	pop    %ebx
801011c6:	5e                   	pop    %esi
801011c7:	5f                   	pop    %edi
801011c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011c9:	e9 c2 24 00 00       	jmp    80103690 <pipewrite>
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 64 74 10 80       	push   $0x80107464
801011d6:	e8 a5 f1 ff ff       	call   80100380 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d b4 15 11 80    	mov    0x801115b4,%ecx
{
801011ef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 8c 00 00 00    	je     80101286 <balloc+0xa6>
801011fa:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
801011fc:	89 f8                	mov    %edi,%eax
801011fe:	83 ec 08             	sub    $0x8,%esp
80101201:	89 fe                	mov    %edi,%esi
80101203:	c1 f8 0c             	sar    $0xc,%eax
80101206:	03 05 cc 15 11 80    	add    0x801115cc,%eax
8010120c:	50                   	push   %eax
8010120d:	ff 75 dc             	push   -0x24(%ebp)
80101210:	e8 bb ee ff ff       	call   801000d0 <bread>
80101215:	83 c4 10             	add    $0x10,%esp
80101218:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010121e:	a1 b4 15 11 80       	mov    0x801115b4,%eax
80101223:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101226:	31 c0                	xor    %eax,%eax
80101228:	eb 32                	jmp    8010125c <balloc+0x7c>
8010122a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
80101249:	89 fa                	mov    %edi,%edx
8010124b:	85 df                	test   %ebx,%edi
8010124d:	74 49                	je     80101298 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124f:	83 c0 01             	add    $0x1,%eax
80101252:	83 c6 01             	add    $0x1,%esi
80101255:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010125a:	74 07                	je     80101263 <balloc+0x83>
8010125c:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010125f:	39 d6                	cmp    %edx,%esi
80101261:	72 cd                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101263:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010126c:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
80101272:	e8 79 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101277:	83 c4 10             	add    $0x10,%esp
8010127a:	3b 3d b4 15 11 80    	cmp    0x801115b4,%edi
80101280:	0f 82 76 ff ff ff    	jb     801011fc <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 6e 74 10 80       	push   $0x8010746e
8010128e:	e8 ed f0 ff ff       	call   80100380 <panic>
80101293:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010129b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010129e:	09 da                	or     %ebx,%edx
801012a0:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012a4:	57                   	push   %edi
801012a5:	e8 66 1d 00 00       	call   80103010 <log_write>
        brelse(bp);
801012aa:	89 3c 24             	mov    %edi,(%esp)
801012ad:	e8 3e ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012b2:	58                   	pop    %eax
801012b3:	5a                   	pop    %edx
801012b4:	56                   	push   %esi
801012b5:	ff 75 dc             	push   -0x24(%ebp)
801012b8:	e8 13 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012bd:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012c0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012c2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012c5:	68 00 02 00 00       	push   $0x200
801012ca:	6a 00                	push   $0x0
801012cc:	50                   	push   %eax
801012cd:	e8 be 34 00 00       	call   80104790 <memset>
  log_write(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 36 1d 00 00       	call   80103010 <log_write>
  brelse(bp);
801012da:	89 1c 24             	mov    %ebx,(%esp)
801012dd:	e8 0e ef ff ff       	call   801001f0 <brelse>
}
801012e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012e5:	89 f0                	mov    %esi,%eax
801012e7:	5b                   	pop    %ebx
801012e8:	5e                   	pop    %esi
801012e9:	5f                   	pop    %edi
801012ea:	5d                   	pop    %ebp
801012eb:	c3                   	ret
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f4:	31 ff                	xor    %edi,%edi
{
801012f6:	56                   	push   %esi
801012f7:	89 c6                	mov    %eax,%esi
801012f9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101305:	68 60 f9 10 80       	push   $0x8010f960
8010130a:	e8 81 33 00 00       	call   80104690 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010130f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101312:	83 c4 10             	add    $0x10,%esp
80101315:	eb 1b                	jmp    80101332 <iget+0x42>
80101317:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010131e:	00 
8010131f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101320:	39 33                	cmp    %esi,(%ebx)
80101322:	74 6c                	je     80101390 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010132a:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101330:	74 26                	je     80101358 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101332:	8b 43 08             	mov    0x8(%ebx),%eax
80101335:	85 c0                	test   %eax,%eax
80101337:	7f e7                	jg     80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101339:	85 ff                	test   %edi,%edi
8010133b:	75 e7                	jne    80101324 <iget+0x34>
8010133d:	85 c0                	test   %eax,%eax
8010133f:	75 76                	jne    801013b7 <iget+0xc7>
      empty = ip;
80101341:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101343:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101349:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
8010134f:	75 e1                	jne    80101332 <iget+0x42>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101358:	85 ff                	test   %edi,%edi
8010135a:	74 79                	je     801013d5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010135c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010135f:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
80101361:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
80101364:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
8010136b:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
80101372:	68 60 f9 10 80       	push   $0x8010f960
80101377:	e8 b4 32 00 00       	call   80104630 <release>

  return ip;
8010137c:	83 c4 10             	add    $0x10,%esp
}
8010137f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101382:	89 f8                	mov    %edi,%eax
80101384:	5b                   	pop    %ebx
80101385:	5e                   	pop    %esi
80101386:	5f                   	pop    %edi
80101387:	5d                   	pop    %ebp
80101388:	c3                   	ret
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 53 04             	cmp    %edx,0x4(%ebx)
80101393:	75 8f                	jne    80101324 <iget+0x34>
      ip->ref++;
80101395:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101398:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010139b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010139d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801013a0:	68 60 f9 10 80       	push   $0x8010f960
801013a5:	e8 86 32 00 00       	call   80104630 <release>
      return ip;
801013aa:	83 c4 10             	add    $0x10,%esp
}
801013ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013b0:	89 f8                	mov    %edi,%eax
801013b2:	5b                   	pop    %ebx
801013b3:	5e                   	pop    %esi
801013b4:	5f                   	pop    %edi
801013b5:	5d                   	pop    %ebp
801013b6:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b7:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013bd:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
801013c3:	74 10                	je     801013d5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c5:	8b 43 08             	mov    0x8(%ebx),%eax
801013c8:	85 c0                	test   %eax,%eax
801013ca:	0f 8f 50 ff ff ff    	jg     80101320 <iget+0x30>
801013d0:	e9 68 ff ff ff       	jmp    8010133d <iget+0x4d>
    panic("iget: no inodes");
801013d5:	83 ec 0c             	sub    $0xc,%esp
801013d8:	68 84 74 10 80       	push   $0x80107484
801013dd:	e8 9e ef ff ff       	call   80100380 <panic>
801013e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801013e9:	00 
801013ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801013f0 <bfree>:
{
801013f0:	55                   	push   %ebp
801013f1:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
801013f3:	89 d0                	mov    %edx,%eax
801013f5:	c1 e8 0c             	shr    $0xc,%eax
{
801013f8:	89 e5                	mov    %esp,%ebp
801013fa:	56                   	push   %esi
801013fb:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
801013fc:	03 05 cc 15 11 80    	add    0x801115cc,%eax
{
80101402:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101404:	83 ec 08             	sub    $0x8,%esp
80101407:	50                   	push   %eax
80101408:	51                   	push   %ecx
80101409:	e8 c2 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010140e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101410:	c1 fb 03             	sar    $0x3,%ebx
80101413:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101416:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101418:	83 e1 07             	and    $0x7,%ecx
8010141b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101420:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101426:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101428:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010142d:	85 c1                	test   %eax,%ecx
8010142f:	74 23                	je     80101454 <bfree+0x64>
  bp->data[bi/8] &= ~m;
80101431:	f7 d0                	not    %eax
  log_write(bp);
80101433:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101436:	21 c8                	and    %ecx,%eax
80101438:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010143c:	56                   	push   %esi
8010143d:	e8 ce 1b 00 00       	call   80103010 <log_write>
  brelse(bp);
80101442:	89 34 24             	mov    %esi,(%esp)
80101445:	e8 a6 ed ff ff       	call   801001f0 <brelse>
}
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101450:	5b                   	pop    %ebx
80101451:	5e                   	pop    %esi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret
    panic("freeing free block");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 94 74 10 80       	push   $0x80107494
8010145c:	e8 1f ef ff ff       	call   80100380 <panic>
80101461:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101468:	00 
80101469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101470 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	56                   	push   %esi
80101475:	89 c6                	mov    %eax,%esi
80101477:	53                   	push   %ebx
80101478:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010147b:	83 fa 0b             	cmp    $0xb,%edx
8010147e:	0f 86 8c 00 00 00    	jbe    80101510 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101484:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101487:	83 fb 7f             	cmp    $0x7f,%ebx
8010148a:	0f 87 a2 00 00 00    	ja     80101532 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101490:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101496:	85 c0                	test   %eax,%eax
80101498:	74 5e                	je     801014f8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010149a:	83 ec 08             	sub    $0x8,%esp
8010149d:	50                   	push   %eax
8010149e:	ff 36                	push   (%esi)
801014a0:	e8 2b ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014a5:	83 c4 10             	add    $0x10,%esp
801014a8:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
801014ac:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
801014ae:	8b 3b                	mov    (%ebx),%edi
801014b0:	85 ff                	test   %edi,%edi
801014b2:	74 1c                	je     801014d0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014b4:	83 ec 0c             	sub    $0xc,%esp
801014b7:	52                   	push   %edx
801014b8:	e8 33 ed ff ff       	call   801001f0 <brelse>
801014bd:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801014c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014c3:	89 f8                	mov    %edi,%eax
801014c5:	5b                   	pop    %ebx
801014c6:	5e                   	pop    %esi
801014c7:	5f                   	pop    %edi
801014c8:	5d                   	pop    %ebp
801014c9:	c3                   	ret
801014ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	e8 06 fd ff ff       	call   801011e0 <balloc>
      log_write(bp);
801014da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014dd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014e0:	89 03                	mov    %eax,(%ebx)
801014e2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801014e4:	52                   	push   %edx
801014e5:	e8 26 1b 00 00       	call   80103010 <log_write>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014ed:	83 c4 10             	add    $0x10,%esp
801014f0:	eb c2                	jmp    801014b4 <bmap+0x44>
801014f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014f8:	8b 06                	mov    (%esi),%eax
801014fa:	e8 e1 fc ff ff       	call   801011e0 <balloc>
801014ff:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101505:	eb 93                	jmp    8010149a <bmap+0x2a>
80101507:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010150e:	00 
8010150f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101510:	8d 5a 14             	lea    0x14(%edx),%ebx
80101513:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101517:	85 ff                	test   %edi,%edi
80101519:	75 a5                	jne    801014c0 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010151b:	8b 00                	mov    (%eax),%eax
8010151d:	e8 be fc ff ff       	call   801011e0 <balloc>
80101522:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101526:	89 c7                	mov    %eax,%edi
}
80101528:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010152b:	5b                   	pop    %ebx
8010152c:	89 f8                	mov    %edi,%eax
8010152e:	5e                   	pop    %esi
8010152f:	5f                   	pop    %edi
80101530:	5d                   	pop    %ebp
80101531:	c3                   	ret
  panic("bmap: out of range");
80101532:	83 ec 0c             	sub    $0xc,%esp
80101535:	68 a7 74 10 80       	push   $0x801074a7
8010153a:	e8 41 ee ff ff       	call   80100380 <panic>
8010153f:	90                   	nop

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	push   0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101555:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101558:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010155a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 ba 32 00 00       	call   80104820 <memmove>
  brelse(bp);
80101566:	83 c4 10             	add    $0x10,%esp
80101569:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 79 ec ff ff       	jmp    801001f0 <brelse>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb a0 f9 10 80       	mov    $0x8010f9a0,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 ba 74 10 80       	push   $0x801074ba
80101591:	68 60 f9 10 80       	push   $0x8010f960
80101596:	e8 05 2f 00 00       	call   801044a0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 c1 74 10 80       	push   $0x801074c1
801015a8:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
801015af:	e8 bc 2d 00 00       	call   80104370 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb c0 15 11 80    	cmp    $0x801115c0,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  bp = bread(dev, 1);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	6a 01                	push   $0x1
801015c4:	ff 75 08             	push   0x8(%ebp)
801015c7:	e8 04 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015cc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015cf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015d1:	8d 40 5c             	lea    0x5c(%eax),%eax
801015d4:	6a 1c                	push   $0x1c
801015d6:	50                   	push   %eax
801015d7:	68 b4 15 11 80       	push   $0x801115b4
801015dc:	e8 3f 32 00 00       	call   80104820 <memmove>
  brelse(bp);
801015e1:	89 1c 24             	mov    %ebx,(%esp)
801015e4:	e8 07 ec ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e9:	ff 35 cc 15 11 80    	push   0x801115cc
801015ef:	ff 35 c8 15 11 80    	push   0x801115c8
801015f5:	ff 35 c4 15 11 80    	push   0x801115c4
801015fb:	ff 35 c0 15 11 80    	push   0x801115c0
80101601:	ff 35 bc 15 11 80    	push   0x801115bc
80101607:	ff 35 b8 15 11 80    	push   0x801115b8
8010160d:	ff 35 b4 15 11 80    	push   0x801115b4
80101613:	68 e4 78 10 80       	push   $0x801078e4
80101618:	e8 93 f0 ff ff       	call   801006b0 <cprintf>
}
8010161d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101620:	83 c4 30             	add    $0x30,%esp
80101623:	c9                   	leave
80101624:	c3                   	ret
80101625:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010162c:	00 
8010162d:	8d 76 00             	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	83 ec 1c             	sub    $0x1c,%esp
80101639:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010163c:	83 3d bc 15 11 80 01 	cmpl   $0x1,0x801115bc
{
80101643:	8b 75 08             	mov    0x8(%ebp),%esi
80101646:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101649:	0f 86 91 00 00 00    	jbe    801016e0 <ialloc+0xb0>
8010164f:	bf 01 00 00 00       	mov    $0x1,%edi
80101654:	eb 21                	jmp    80101677 <ialloc+0x47>
80101656:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010165d:	00 
8010165e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d bc 15 11 80    	cmp    0x801115bc,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	6a 40                	push   $0x40
801016a8:	6a 00                	push   $0x0
801016aa:	51                   	push   %ecx
801016ab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016ae:	e8 dd 30 00 00       	call   80104790 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 4b 19 00 00       	call   80103010 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 10 fc ff ff       	jmp    801012f0 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 c7 74 10 80       	push   $0x801074c7
801016e8:	e8 93 ec ff ff       	call   80100380 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	55                   	push   %ebp
801016f1:	89 e5                	mov    %esp,%ebp
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	c1 e8 03             	shr    $0x3,%eax
80101704:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010170a:	50                   	push   %eax
8010170b:	ff 73 a4             	push   -0x5c(%ebx)
8010170e:	e8 bd e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101713:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101717:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101729:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010172c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101730:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101733:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101737:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010173f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101743:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101747:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010174d:	6a 34                	push   $0x34
8010174f:	53                   	push   %ebx
80101750:	50                   	push   %eax
80101751:	e8 ca 30 00 00       	call   80104820 <memmove>
  log_write(bp);
80101756:	89 34 24             	mov    %esi,(%esp)
80101759:	e8 b2 18 00 00       	call   80103010 <log_write>
  brelse(bp);
8010175e:	83 c4 10             	add    $0x10,%esp
80101761:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101764:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101767:	5b                   	pop    %ebx
80101768:	5e                   	pop    %esi
80101769:	5d                   	pop    %ebp
  brelse(bp);
8010176a:	e9 81 ea ff ff       	jmp    801001f0 <brelse>
8010176f:	90                   	nop

80101770 <idup>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	53                   	push   %ebx
80101774:	83 ec 10             	sub    $0x10,%esp
80101777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010177a:	68 60 f9 10 80       	push   $0x8010f960
8010177f:	e8 0c 2f 00 00       	call   80104690 <acquire>
  ip->ref++;
80101784:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101788:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010178f:	e8 9c 2e 00 00       	call   80104630 <release>
}
80101794:	89 d8                	mov    %ebx,%eax
80101796:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101799:	c9                   	leave
8010179a:	c3                   	ret
8010179b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801017a0 <ilock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	0f 84 b7 00 00 00    	je     80101867 <ilock+0xc7>
801017b0:	8b 53 08             	mov    0x8(%ebx),%edx
801017b3:	85 d2                	test   %edx,%edx
801017b5:	0f 8e ac 00 00 00    	jle    80101867 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017bb:	83 ec 0c             	sub    $0xc,%esp
801017be:	8d 43 0c             	lea    0xc(%ebx),%eax
801017c1:	50                   	push   %eax
801017c2:	e8 e9 2b 00 00       	call   801043b0 <acquiresleep>
  if(ip->valid == 0){
801017c7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ca:	83 c4 10             	add    $0x10,%esp
801017cd:	85 c0                	test   %eax,%eax
801017cf:	74 0f                	je     801017e0 <ilock+0x40>
}
801017d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d4:	5b                   	pop    %ebx
801017d5:	5e                   	pop    %esi
801017d6:	5d                   	pop    %ebp
801017d7:	c3                   	ret
801017d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801017df:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e0:	8b 43 04             	mov    0x4(%ebx),%eax
801017e3:	83 ec 08             	sub    $0x8,%esp
801017e6:	c1 e8 03             	shr    $0x3,%eax
801017e9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801017ef:	50                   	push   %eax
801017f0:	ff 33                	push   (%ebx)
801017f2:	e8 d9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017fc:	8b 43 04             	mov    0x4(%ebx),%eax
801017ff:	83 e0 07             	and    $0x7,%eax
80101802:	c1 e0 06             	shl    $0x6,%eax
80101805:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101809:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010180c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010180f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101813:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101817:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010181b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010181f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101823:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101827:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010182b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010182e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101831:	6a 34                	push   $0x34
80101833:	50                   	push   %eax
80101834:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101837:	50                   	push   %eax
80101838:	e8 e3 2f 00 00       	call   80104820 <memmove>
    brelse(bp);
8010183d:	89 34 24             	mov    %esi,(%esp)
80101840:	e8 ab e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101845:	83 c4 10             	add    $0x10,%esp
80101848:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010184d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101854:	0f 85 77 ff ff ff    	jne    801017d1 <ilock+0x31>
      panic("ilock: no type");
8010185a:	83 ec 0c             	sub    $0xc,%esp
8010185d:	68 df 74 10 80       	push   $0x801074df
80101862:	e8 19 eb ff ff       	call   80100380 <panic>
    panic("ilock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 d9 74 10 80       	push   $0x801074d9
8010186f:	e8 0c eb ff ff       	call   80100380 <panic>
80101874:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010187b:	00 
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101880 <iunlock>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	56                   	push   %esi
80101884:	53                   	push   %ebx
80101885:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101888:	85 db                	test   %ebx,%ebx
8010188a:	74 28                	je     801018b4 <iunlock+0x34>
8010188c:	83 ec 0c             	sub    $0xc,%esp
8010188f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101892:	56                   	push   %esi
80101893:	e8 b8 2b 00 00       	call   80104450 <holdingsleep>
80101898:	83 c4 10             	add    $0x10,%esp
8010189b:	85 c0                	test   %eax,%eax
8010189d:	74 15                	je     801018b4 <iunlock+0x34>
8010189f:	8b 43 08             	mov    0x8(%ebx),%eax
801018a2:	85 c0                	test   %eax,%eax
801018a4:	7e 0e                	jle    801018b4 <iunlock+0x34>
  releasesleep(&ip->lock);
801018a6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018ac:	5b                   	pop    %ebx
801018ad:	5e                   	pop    %esi
801018ae:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018af:	e9 5c 2b 00 00       	jmp    80104410 <releasesleep>
    panic("iunlock");
801018b4:	83 ec 0c             	sub    $0xc,%esp
801018b7:	68 ee 74 10 80       	push   $0x801074ee
801018bc:	e8 bf ea ff ff       	call   80100380 <panic>
801018c1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018c8:	00 
801018c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iput>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 28             	sub    $0x28,%esp
801018d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018dc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018df:	57                   	push   %edi
801018e0:	e8 cb 2a 00 00       	call   801043b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018e5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018e8:	83 c4 10             	add    $0x10,%esp
801018eb:	85 d2                	test   %edx,%edx
801018ed:	74 07                	je     801018f6 <iput+0x26>
801018ef:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018f4:	74 32                	je     80101928 <iput+0x58>
  releasesleep(&ip->lock);
801018f6:	83 ec 0c             	sub    $0xc,%esp
801018f9:	57                   	push   %edi
801018fa:	e8 11 2b 00 00       	call   80104410 <releasesleep>
  acquire(&icache.lock);
801018ff:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101906:	e8 85 2d 00 00       	call   80104690 <acquire>
  ip->ref--;
8010190b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010190f:	83 c4 10             	add    $0x10,%esp
80101912:	c7 45 08 60 f9 10 80 	movl   $0x8010f960,0x8(%ebp)
}
80101919:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5f                   	pop    %edi
8010191f:	5d                   	pop    %ebp
  release(&icache.lock);
80101920:	e9 0b 2d 00 00       	jmp    80104630 <release>
80101925:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101928:	83 ec 0c             	sub    $0xc,%esp
8010192b:	68 60 f9 10 80       	push   $0x8010f960
80101930:	e8 5b 2d 00 00       	call   80104690 <acquire>
    int r = ip->ref;
80101935:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101938:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010193f:	e8 ec 2c 00 00       	call   80104630 <release>
    if(r == 1){
80101944:	83 c4 10             	add    $0x10,%esp
80101947:	83 fe 01             	cmp    $0x1,%esi
8010194a:	75 aa                	jne    801018f6 <iput+0x26>
8010194c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101952:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101955:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101958:	89 df                	mov    %ebx,%edi
8010195a:	89 cb                	mov    %ecx,%ebx
8010195c:	eb 09                	jmp    80101967 <iput+0x97>
8010195e:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101960:	83 c6 04             	add    $0x4,%esi
80101963:	39 de                	cmp    %ebx,%esi
80101965:	74 19                	je     80101980 <iput+0xb0>
    if(ip->addrs[i]){
80101967:	8b 16                	mov    (%esi),%edx
80101969:	85 d2                	test   %edx,%edx
8010196b:	74 f3                	je     80101960 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010196d:	8b 07                	mov    (%edi),%eax
8010196f:	e8 7c fa ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101974:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010197a:	eb e4                	jmp    80101960 <iput+0x90>
8010197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101980:	89 fb                	mov    %edi,%ebx
80101982:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101985:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010198b:	85 c0                	test   %eax,%eax
8010198d:	75 2d                	jne    801019bc <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010198f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101992:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101999:	53                   	push   %ebx
8010199a:	e8 51 fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
8010199f:	31 c0                	xor    %eax,%eax
801019a1:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019a5:	89 1c 24             	mov    %ebx,(%esp)
801019a8:	e8 43 fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019ad:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	e9 3a ff ff ff       	jmp    801018f6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	50                   	push   %eax
801019c0:	ff 33                	push   (%ebx)
801019c2:	e8 09 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801019c7:	83 c4 10             	add    $0x10,%esp
801019ca:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019cd:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019d6:	8d 70 5c             	lea    0x5c(%eax),%esi
801019d9:	89 cf                	mov    %ecx,%edi
801019db:	eb 0a                	jmp    801019e7 <iput+0x117>
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 fe                	cmp    %edi,%esi
801019e5:	74 0f                	je     801019f6 <iput+0x126>
      if(a[j])
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x110>
        bfree(ip->dev, a[j]);
801019ed:	8b 03                	mov    (%ebx),%eax
801019ef:	e8 fc f9 ff ff       	call   801013f0 <bfree>
801019f4:	eb ea                	jmp    801019e0 <iput+0x110>
    brelse(bp);
801019f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019f9:	83 ec 0c             	sub    $0xc,%esp
801019fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ff:	50                   	push   %eax
80101a00:	e8 eb e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a05:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a0b:	8b 03                	mov    (%ebx),%eax
80101a0d:	e8 de f9 ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a12:	83 c4 10             	add    $0x10,%esp
80101a15:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a1c:	00 00 00 
80101a1f:	e9 6b ff ff ff       	jmp    8010198f <iput+0xbf>
80101a24:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a2b:	00 
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <iunlockput>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	74 34                	je     80101a70 <iunlockput+0x40>
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a42:	56                   	push   %esi
80101a43:	e8 08 2a 00 00       	call   80104450 <holdingsleep>
80101a48:	83 c4 10             	add    $0x10,%esp
80101a4b:	85 c0                	test   %eax,%eax
80101a4d:	74 21                	je     80101a70 <iunlockput+0x40>
80101a4f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	7e 1a                	jle    80101a70 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101a56:	83 ec 0c             	sub    $0xc,%esp
80101a59:	56                   	push   %esi
80101a5a:	e8 b1 29 00 00       	call   80104410 <releasesleep>
  iput(ip);
80101a5f:	83 c4 10             	add    $0x10,%esp
80101a62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101a65:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5d                   	pop    %ebp
  iput(ip);
80101a6b:	e9 60 fe ff ff       	jmp    801018d0 <iput>
    panic("iunlock");
80101a70:	83 ec 0c             	sub    $0xc,%esp
80101a73:	68 ee 74 10 80       	push   $0x801074ee
80101a78:	e8 03 e9 ff ff       	call   80100380 <panic>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	55                   	push   %ebp
80101a81:	89 e5                	mov    %esp,%ebp
80101a83:	8b 55 08             	mov    0x8(%ebp),%edx
80101a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a89:	8b 0a                	mov    (%edx),%ecx
80101a8b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a8e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a91:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a94:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a98:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a9f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa3:	8b 52 58             	mov    0x58(%edx),%edx
80101aa6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aa9:	5d                   	pop    %ebp
80101aaa:	c3                   	ret
80101aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	57                   	push   %edi
80101ab4:	56                   	push   %esi
80101ab5:	53                   	push   %ebx
80101ab6:	83 ec 1c             	sub    $0x1c,%esp
80101ab9:	8b 75 08             	mov    0x8(%ebp),%esi
80101abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ac2:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101ac7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101aca:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101acd:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101ad0:	0f 84 aa 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101ad6:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101ad9:	8b 56 58             	mov    0x58(%esi),%edx
80101adc:	39 fa                	cmp    %edi,%edx
80101ade:	0f 82 bd 00 00 00    	jb     80101ba1 <readi+0xf1>
80101ae4:	89 f9                	mov    %edi,%ecx
80101ae6:	31 db                	xor    %ebx,%ebx
80101ae8:	01 c1                	add    %eax,%ecx
80101aea:	0f 92 c3             	setb   %bl
80101aed:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101af0:	0f 82 ab 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101af6:	89 d3                	mov    %edx,%ebx
80101af8:	29 fb                	sub    %edi,%ebx
80101afa:	39 ca                	cmp    %ecx,%edx
80101afc:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	85 c0                	test   %eax,%eax
80101b01:	74 73                	je     80101b76 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 fa                	mov    %edi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 51 f9 ff ff       	call   80101470 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	push   (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b32:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b34:	89 f8                	mov    %edi,%eax
80101b36:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3b:	29 f3                	sub    %esi,%ebx
80101b3d:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b3f:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	39 d9                	cmp    %ebx,%ecx
80101b45:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b48:	83 c4 0c             	add    $0xc,%esp
80101b4b:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4c:	01 de                	add    %ebx,%esi
80101b4e:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	push   -0x20(%ebp)
80101b57:	e8 c4 2c 00 00       	call   80104820 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b6d:	83 c4 10             	add    $0x10,%esp
80101b70:	39 de                	cmp    %ebx,%esi
80101b72:	72 9c                	jb     80101b10 <readi+0x60>
80101b74:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101b76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b79:	5b                   	pop    %ebx
80101b7a:	5e                   	pop    %esi
80101b7b:	5f                   	pop    %edi
80101b7c:	5d                   	pop    %ebp
80101b7d:	c3                   	ret
80101b7e:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101b84:	66 83 fa 09          	cmp    $0x9,%dx
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 14 d5 00 f9 10 80 	mov    -0x7fef0700(,%edx,8),%edx
80101b91:	85 d2                	test   %edx,%edx
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e2                	jmp    *%edx
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb ce                	jmp    80101b76 <readi+0xc6>
80101ba8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101baf:	00 

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	57                   	push   %edi
80101bb4:	56                   	push   %esi
80101bb5:	53                   	push   %ebx
80101bb6:	83 ec 1c             	sub    $0x1c,%esp
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bbf:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bc7:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101bca:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101bcd:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101bd0:	0f 84 ba 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bd6:	39 78 58             	cmp    %edi,0x58(%eax)
80101bd9:	0f 82 ea 00 00 00    	jb     80101cc9 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bdf:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101be2:	89 f2                	mov    %esi,%edx
80101be4:	01 fa                	add    %edi,%edx
80101be6:	0f 82 dd 00 00 00    	jb     80101cc9 <writei+0x119>
80101bec:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101bf2:	0f 87 d1 00 00 00    	ja     80101cc9 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bf8:	85 f6                	test   %esi,%esi
80101bfa:	0f 84 85 00 00 00    	je     80101c85 <writei+0xd5>
80101c00:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c13:	89 fa                	mov    %edi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f0                	mov    %esi,%eax
80101c1a:	e8 51 f8 ff ff       	call   80101470 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 36                	push   (%esi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c2d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c30:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f8                	mov    %edi,%eax
80101c39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c3e:	29 d3                	sub    %edx,%ebx
80101c40:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c42:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c46:	39 d9                	cmp    %ebx,%ecx
80101c48:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4b:	83 c4 0c             	add    $0xc,%esp
80101c4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4f:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101c51:	ff 75 dc             	push   -0x24(%ebp)
80101c54:	50                   	push   %eax
80101c55:	e8 c6 2b 00 00       	call   80104820 <memmove>
    log_write(bp);
80101c5a:	89 34 24             	mov    %esi,(%esp)
80101c5d:	e8 ae 13 00 00       	call   80103010 <log_write>
    brelse(bp);
80101c62:	89 34 24             	mov    %esi,(%esp)
80101c65:	e8 86 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c6a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c70:	83 c4 10             	add    $0x10,%esp
80101c73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c76:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c79:	39 d8                	cmp    %ebx,%eax
80101c7b:	72 93                	jb     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c80:	39 78 58             	cmp    %edi,0x58(%eax)
80101c83:	72 33                	jb     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 2f                	ja     80101cc9 <writei+0x119>
80101c9a:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 24                	je     80101cc9 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101cb8:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbb:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101cbe:	50                   	push   %eax
80101cbf:	e8 2c fa ff ff       	call   801016f0 <iupdate>
80101cc4:	83 c4 10             	add    $0x10,%esp
80101cc7:	eb bc                	jmp    80101c85 <writei+0xd5>
      return -1;
80101cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cce:	eb b8                	jmp    80101c88 <writei+0xd8>

80101cd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cd6:	6a 0e                	push   $0xe
80101cd8:	ff 75 0c             	push   0xc(%ebp)
80101cdb:	ff 75 08             	push   0x8(%ebp)
80101cde:	e8 ad 2b 00 00       	call   80104890 <strncmp>
}
80101ce3:	c9                   	leave
80101ce4:	c3                   	ret
80101ce5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101cec:	00 
80101ced:	8d 76 00             	lea    0x0(%esi),%esi

80101cf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	83 ec 1c             	sub    $0x1c,%esp
80101cf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d01:	0f 85 85 00 00 00    	jne    80101d8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d07:	8b 53 58             	mov    0x58(%ebx),%edx
80101d0a:	31 ff                	xor    %edi,%edi
80101d0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d0f:	85 d2                	test   %edx,%edx
80101d11:	74 3e                	je     80101d51 <dirlookup+0x61>
80101d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d18:	6a 10                	push   $0x10
80101d1a:	57                   	push   %edi
80101d1b:	56                   	push   %esi
80101d1c:	53                   	push   %ebx
80101d1d:	e8 8e fd ff ff       	call   80101ab0 <readi>
80101d22:	83 c4 10             	add    $0x10,%esp
80101d25:	83 f8 10             	cmp    $0x10,%eax
80101d28:	75 55                	jne    80101d7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d2f:	74 18                	je     80101d49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101d31:	83 ec 04             	sub    $0x4,%esp
80101d34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d37:	6a 0e                	push   $0xe
80101d39:	50                   	push   %eax
80101d3a:	ff 75 0c             	push   0xc(%ebp)
80101d3d:	e8 4e 2b 00 00       	call   80104890 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d42:	83 c4 10             	add    $0x10,%esp
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 17                	je     80101d60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d49:	83 c7 10             	add    $0x10,%edi
80101d4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d4f:	72 c7                	jb     80101d18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d54:	31 c0                	xor    %eax,%eax
}
80101d56:	5b                   	pop    %ebx
80101d57:	5e                   	pop    %esi
80101d58:	5f                   	pop    %edi
80101d59:	5d                   	pop    %ebp
80101d5a:	c3                   	ret
80101d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101d60:	8b 45 10             	mov    0x10(%ebp),%eax
80101d63:	85 c0                	test   %eax,%eax
80101d65:	74 05                	je     80101d6c <dirlookup+0x7c>
        *poff = off;
80101d67:	8b 45 10             	mov    0x10(%ebp),%eax
80101d6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d70:	8b 03                	mov    (%ebx),%eax
80101d72:	e8 79 f5 ff ff       	call   801012f0 <iget>
}
80101d77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d7a:	5b                   	pop    %ebx
80101d7b:	5e                   	pop    %esi
80101d7c:	5f                   	pop    %edi
80101d7d:	5d                   	pop    %ebp
80101d7e:	c3                   	ret
      panic("dirlookup read");
80101d7f:	83 ec 0c             	sub    $0xc,%esp
80101d82:	68 08 75 10 80       	push   $0x80107508
80101d87:	e8 f4 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101d8c:	83 ec 0c             	sub    $0xc,%esp
80101d8f:	68 f6 74 10 80       	push   $0x801074f6
80101d94:	e8 e7 e5 ff ff       	call   80100380 <panic>
80101d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101da0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101da0:	55                   	push   %ebp
80101da1:	89 e5                	mov    %esp,%ebp
80101da3:	57                   	push   %edi
80101da4:	56                   	push   %esi
80101da5:	53                   	push   %ebx
80101da6:	89 c3                	mov    %eax,%ebx
80101da8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101db4:	0f 84 9e 01 00 00    	je     80101f58 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dba:	e8 91 1c 00 00       	call   80103a50 <myproc>
  acquire(&icache.lock);
80101dbf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101dc2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101dc5:	68 60 f9 10 80       	push   $0x8010f960
80101dca:	e8 c1 28 00 00       	call   80104690 <acquire>
  ip->ref++;
80101dcf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101dd3:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101dda:	e8 51 28 00 00       	call   80104630 <release>
80101ddf:	83 c4 10             	add    $0x10,%esp
80101de2:	eb 07                	jmp    80101deb <namex+0x4b>
80101de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101de8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101deb:	0f b6 03             	movzbl (%ebx),%eax
80101dee:	3c 2f                	cmp    $0x2f,%al
80101df0:	74 f6                	je     80101de8 <namex+0x48>
  if(*path == 0)
80101df2:	84 c0                	test   %al,%al
80101df4:	0f 84 06 01 00 00    	je     80101f00 <namex+0x160>
  while(*path != '/' && *path != 0)
80101dfa:	0f b6 03             	movzbl (%ebx),%eax
80101dfd:	84 c0                	test   %al,%al
80101dff:	0f 84 10 01 00 00    	je     80101f15 <namex+0x175>
80101e05:	89 df                	mov    %ebx,%edi
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	0f 84 06 01 00 00    	je     80101f15 <namex+0x175>
80101e0f:	90                   	nop
80101e10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e17:	3c 2f                	cmp    $0x2f,%al
80101e19:	74 04                	je     80101e1f <namex+0x7f>
80101e1b:	84 c0                	test   %al,%al
80101e1d:	75 f1                	jne    80101e10 <namex+0x70>
  len = path - s;
80101e1f:	89 f8                	mov    %edi,%eax
80101e21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e23:	83 f8 0d             	cmp    $0xd,%eax
80101e26:	0f 8e ac 00 00 00    	jle    80101ed8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	6a 0e                	push   $0xe
80101e31:	53                   	push   %ebx
80101e32:	89 fb                	mov    %edi,%ebx
80101e34:	ff 75 e4             	push   -0x1c(%ebp)
80101e37:	e8 e4 29 00 00       	call   80104820 <memmove>
80101e3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e42:	75 0c                	jne    80101e50 <namex+0xb0>
80101e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e4e:	74 f8                	je     80101e48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e50:	83 ec 0c             	sub    $0xc,%esp
80101e53:	56                   	push   %esi
80101e54:	e8 47 f9 ff ff       	call   801017a0 <ilock>
    if(ip->type != T_DIR){
80101e59:	83 c4 10             	add    $0x10,%esp
80101e5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e61:	0f 85 b7 00 00 00    	jne    80101f1e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 09                	je     80101e77 <namex+0xd7>
80101e6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e71:	0f 84 f7 00 00 00    	je     80101f6e <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e77:	83 ec 04             	sub    $0x4,%esp
80101e7a:	6a 00                	push   $0x0
80101e7c:	ff 75 e4             	push   -0x1c(%ebp)
80101e7f:	56                   	push   %esi
80101e80:	e8 6b fe ff ff       	call   80101cf0 <dirlookup>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 c7                	mov    %eax,%edi
80101e8a:	85 c0                	test   %eax,%eax
80101e8c:	0f 84 8c 00 00 00    	je     80101f1e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101e92:	83 ec 0c             	sub    $0xc,%esp
80101e95:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101e98:	51                   	push   %ecx
80101e99:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101e9c:	e8 af 25 00 00       	call   80104450 <holdingsleep>
80101ea1:	83 c4 10             	add    $0x10,%esp
80101ea4:	85 c0                	test   %eax,%eax
80101ea6:	0f 84 02 01 00 00    	je     80101fae <namex+0x20e>
80101eac:	8b 56 08             	mov    0x8(%esi),%edx
80101eaf:	85 d2                	test   %edx,%edx
80101eb1:	0f 8e f7 00 00 00    	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101eb7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101eba:	83 ec 0c             	sub    $0xc,%esp
80101ebd:	51                   	push   %ecx
80101ebe:	e8 4d 25 00 00       	call   80104410 <releasesleep>
  iput(ip);
80101ec3:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101ec6:	89 fe                	mov    %edi,%esi
  iput(ip);
80101ec8:	e8 03 fa ff ff       	call   801018d0 <iput>
80101ecd:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ed0:	e9 16 ff ff ff       	jmp    80101deb <namex+0x4b>
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101ed8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101edb:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101ede:	83 ec 04             	sub    $0x4,%esp
80101ee1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101ee4:	50                   	push   %eax
80101ee5:	53                   	push   %ebx
    name[len] = 0;
80101ee6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101ee8:	ff 75 e4             	push   -0x1c(%ebp)
80101eeb:	e8 30 29 00 00       	call   80104820 <memmove>
    name[len] = 0;
80101ef0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ef3:	83 c4 10             	add    $0x10,%esp
80101ef6:	c6 01 00             	movb   $0x0,(%ecx)
80101ef9:	e9 41 ff ff ff       	jmp    80101e3f <namex+0x9f>
80101efe:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f00:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f03:	85 c0                	test   %eax,%eax
80101f05:	0f 85 93 00 00 00    	jne    80101f9e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0e:	89 f0                	mov    %esi,%eax
80101f10:	5b                   	pop    %ebx
80101f11:	5e                   	pop    %esi
80101f12:	5f                   	pop    %edi
80101f13:	5d                   	pop    %ebp
80101f14:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f18:	89 df                	mov    %ebx,%edi
80101f1a:	31 c0                	xor    %eax,%eax
80101f1c:	eb c0                	jmp    80101ede <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f1e:	83 ec 0c             	sub    $0xc,%esp
80101f21:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f24:	53                   	push   %ebx
80101f25:	e8 26 25 00 00       	call   80104450 <holdingsleep>
80101f2a:	83 c4 10             	add    $0x10,%esp
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	74 7d                	je     80101fae <namex+0x20e>
80101f31:	8b 4e 08             	mov    0x8(%esi),%ecx
80101f34:	85 c9                	test   %ecx,%ecx
80101f36:	7e 76                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	53                   	push   %ebx
80101f3c:	e8 cf 24 00 00       	call   80104410 <releasesleep>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 85 f9 ff ff       	call   801018d0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101f58:	ba 01 00 00 00       	mov    $0x1,%edx
80101f5d:	b8 01 00 00 00       	mov    $0x1,%eax
80101f62:	e8 89 f3 ff ff       	call   801012f0 <iget>
80101f67:	89 c6                	mov    %eax,%esi
80101f69:	e9 7d fe ff ff       	jmp    80101deb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f6e:	83 ec 0c             	sub    $0xc,%esp
80101f71:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f74:	53                   	push   %ebx
80101f75:	e8 d6 24 00 00       	call   80104450 <holdingsleep>
80101f7a:	83 c4 10             	add    $0x10,%esp
80101f7d:	85 c0                	test   %eax,%eax
80101f7f:	74 2d                	je     80101fae <namex+0x20e>
80101f81:	8b 7e 08             	mov    0x8(%esi),%edi
80101f84:	85 ff                	test   %edi,%edi
80101f86:	7e 26                	jle    80101fae <namex+0x20e>
  releasesleep(&ip->lock);
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	53                   	push   %ebx
80101f8c:	e8 7f 24 00 00       	call   80104410 <releasesleep>
}
80101f91:	83 c4 10             	add    $0x10,%esp
}
80101f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f97:	89 f0                	mov    %esi,%eax
80101f99:	5b                   	pop    %ebx
80101f9a:	5e                   	pop    %esi
80101f9b:	5f                   	pop    %edi
80101f9c:	5d                   	pop    %ebp
80101f9d:	c3                   	ret
    iput(ip);
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	56                   	push   %esi
      return 0;
80101fa2:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa4:	e8 27 f9 ff ff       	call   801018d0 <iput>
    return 0;
80101fa9:	83 c4 10             	add    $0x10,%esp
80101fac:	eb a0                	jmp    80101f4e <namex+0x1ae>
    panic("iunlock");
80101fae:	83 ec 0c             	sub    $0xc,%esp
80101fb1:	68 ee 74 10 80       	push   $0x801074ee
80101fb6:	e8 c5 e3 ff ff       	call   80100380 <panic>
80101fbb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101fc0 <dirlink>:
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 20             	sub    $0x20,%esp
80101fc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fcc:	6a 00                	push   $0x0
80101fce:	ff 75 0c             	push   0xc(%ebp)
80101fd1:	53                   	push   %ebx
80101fd2:	e8 19 fd ff ff       	call   80101cf0 <dirlookup>
80101fd7:	83 c4 10             	add    $0x10,%esp
80101fda:	85 c0                	test   %eax,%eax
80101fdc:	75 67                	jne    80102045 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe4:	85 ff                	test   %edi,%edi
80101fe6:	74 29                	je     80102011 <dirlink+0x51>
80101fe8:	31 ff                	xor    %edi,%edi
80101fea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fed:	eb 09                	jmp    80101ff8 <dirlink+0x38>
80101fef:	90                   	nop
80101ff0:	83 c7 10             	add    $0x10,%edi
80101ff3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ff6:	73 19                	jae    80102011 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff8:	6a 10                	push   $0x10
80101ffa:	57                   	push   %edi
80101ffb:	56                   	push   %esi
80101ffc:	53                   	push   %ebx
80101ffd:	e8 ae fa ff ff       	call   80101ab0 <readi>
80102002:	83 c4 10             	add    $0x10,%esp
80102005:	83 f8 10             	cmp    $0x10,%eax
80102008:	75 4e                	jne    80102058 <dirlink+0x98>
    if(de.inum == 0)
8010200a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010200f:	75 df                	jne    80101ff0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102011:	83 ec 04             	sub    $0x4,%esp
80102014:	8d 45 da             	lea    -0x26(%ebp),%eax
80102017:	6a 0e                	push   $0xe
80102019:	ff 75 0c             	push   0xc(%ebp)
8010201c:	50                   	push   %eax
8010201d:	e8 be 28 00 00       	call   801048e0 <strncpy>
  de.inum = inum;
80102022:	8b 45 10             	mov    0x10(%ebp),%eax
80102025:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102029:	6a 10                	push   $0x10
8010202b:	57                   	push   %edi
8010202c:	56                   	push   %esi
8010202d:	53                   	push   %ebx
8010202e:	e8 7d fb ff ff       	call   80101bb0 <writei>
80102033:	83 c4 20             	add    $0x20,%esp
80102036:	83 f8 10             	cmp    $0x10,%eax
80102039:	75 2a                	jne    80102065 <dirlink+0xa5>
  return 0;
8010203b:	31 c0                	xor    %eax,%eax
}
8010203d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102040:	5b                   	pop    %ebx
80102041:	5e                   	pop    %esi
80102042:	5f                   	pop    %edi
80102043:	5d                   	pop    %ebp
80102044:	c3                   	ret
    iput(ip);
80102045:	83 ec 0c             	sub    $0xc,%esp
80102048:	50                   	push   %eax
80102049:	e8 82 f8 ff ff       	call   801018d0 <iput>
    return -1;
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102056:	eb e5                	jmp    8010203d <dirlink+0x7d>
      panic("dirlink read");
80102058:	83 ec 0c             	sub    $0xc,%esp
8010205b:	68 17 75 10 80       	push   $0x80107517
80102060:	e8 1b e3 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102065:	83 ec 0c             	sub    $0xc,%esp
80102068:	68 73 77 10 80       	push   $0x80107773
8010206d:	e8 0e e3 ff ff       	call   80100380 <panic>
80102072:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102079:	00 
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102081:	31 d2                	xor    %edx,%edx
{
80102083:	89 e5                	mov    %esp,%ebp
80102085:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102088:	8b 45 08             	mov    0x8(%ebp),%eax
8010208b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010208e:	e8 0d fd ff ff       	call   80101da0 <namex>
}
80102093:	c9                   	leave
80102094:	c3                   	ret
80102095:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010209c:	00 
8010209d:	8d 76 00             	lea    0x0(%esi),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	55                   	push   %ebp
  return namex(path, 1, name);
801020a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020af:	e9 ec fc ff ff       	jmp    80101da0 <namex>
801020b4:	66 90                	xchg   %ax,%ax
801020b6:	66 90                	xchg   %ax,%ax
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020ee:	00 
801020ef:	90                   	nop
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 2d 75 10 80       	push   $0x8010752d
80102180:	e8 fb e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 24 75 10 80       	push   $0x80107524
8010218d:	e8 ee e1 ff ff       	call   80100380 <panic>
80102192:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102199:	00 
8010219a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801021a0 <ideinit>:
{
801021a0:	55                   	push   %ebp
801021a1:	89 e5                	mov    %esp,%ebp
801021a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021a6:	68 3f 75 10 80       	push   $0x8010753f
801021ab:	68 00 16 11 80       	push   $0x80111600
801021b0:	e8 eb 22 00 00       	call   801044a0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b5:	58                   	pop    %eax
801021b6:	a1 84 17 18 80       	mov    0x80181784,%eax
801021bb:	5a                   	pop    %edx
801021bc:	83 e8 01             	sub    $0x1,%eax
801021bf:	50                   	push   %eax
801021c0:	6a 0e                	push   $0xe
801021c2:	e8 99 02 00 00       	call   80102460 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ca:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021cf:	90                   	nop
801021d0:	89 ca                	mov    %ecx,%edx
801021d2:	ec                   	in     (%dx),%al
801021d3:	83 e0 c0             	and    $0xffffffc0,%eax
801021d6:	3c 40                	cmp    $0x40,%al
801021d8:	75 f6                	jne    801021d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021da:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021df:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021e4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021e5:	89 ca                	mov    %ecx,%edx
801021e7:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021e8:	84 c0                	test   %al,%al
801021ea:	75 1e                	jne    8010220a <ideinit+0x6a>
801021ec:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
801021f1:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801021fd:	00 
801021fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave
80102220:	c3                   	ret
80102221:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102228:	00 
80102229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 00 16 11 80       	push   $0x80111600
8010223e:	e8 4d 24 00 00       	call   80104690 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 63                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 33                	mov    (%ebx),%esi
8010225a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102260:	75 2f                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226e:	00 
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010228f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 2e 1f 00 00       	call   801041d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 e4 15 11 80       	mov    0x801115e4,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 00 16 11 80       	push   $0x80111600
801022bb:	e8 70 23 00 00       	call   80104630 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret
801022c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022cf:	00 

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 6d 21 00 00       	call   80104450 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c3 00 00 00    	je     801023b1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 a8 00 00 00    	je     801023a4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 e0 15 11 80       	mov    0x801115e0,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 87 00 00 00    	je     80102397 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 00 16 11 80       	push   $0x80111600
80102318:	e8 73 23 00 00       	call   80104690 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	a1 e4 15 11 80       	mov    0x801115e4,%eax
  b->qnext = 0;
80102322:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102329:	83 c4 10             	add    $0x10,%esp
8010232c:	85 c0                	test   %eax,%eax
8010232e:	74 60                	je     80102390 <iderw+0xc0>
80102330:	89 c2                	mov    %eax,%edx
80102332:	8b 40 58             	mov    0x58(%eax),%eax
80102335:	85 c0                	test   %eax,%eax
80102337:	75 f7                	jne    80102330 <iderw+0x60>
80102339:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010233c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010233e:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80102344:	74 3a                	je     80102380 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102346:	8b 03                	mov    (%ebx),%eax
80102348:	83 e0 06             	and    $0x6,%eax
8010234b:	83 f8 02             	cmp    $0x2,%eax
8010234e:	74 1b                	je     8010236b <iderw+0x9b>
    sleep(b, &idelock);
80102350:	83 ec 08             	sub    $0x8,%esp
80102353:	68 00 16 11 80       	push   $0x80111600
80102358:	53                   	push   %ebx
80102359:	e8 b2 1d 00 00       	call   80104110 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 c4 10             	add    $0x10,%esp
80102363:	83 e0 06             	and    $0x6,%eax
80102366:	83 f8 02             	cmp    $0x2,%eax
80102369:	75 e5                	jne    80102350 <iderw+0x80>
  }


  release(&idelock);
8010236b:	c7 45 08 00 16 11 80 	movl   $0x80111600,0x8(%ebp)
}
80102372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102375:	c9                   	leave
  release(&idelock);
80102376:	e9 b5 22 00 00       	jmp    80104630 <release>
8010237b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102380:	89 d8                	mov    %ebx,%eax
80102382:	e8 39 fd ff ff       	call   801020c0 <idestart>
80102387:	eb bd                	jmp    80102346 <iderw+0x76>
80102389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102390:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80102395:	eb a5                	jmp    8010233c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102397:	83 ec 0c             	sub    $0xc,%esp
8010239a:	68 6e 75 10 80       	push   $0x8010756e
8010239f:	e8 dc df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801023a4:	83 ec 0c             	sub    $0xc,%esp
801023a7:	68 59 75 10 80       	push   $0x80107559
801023ac:	e8 cf df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801023b1:	83 ec 0c             	sub    $0xc,%esp
801023b4:	68 43 75 10 80       	push   $0x80107543
801023b9:	e8 c2 df ff ff       	call   80100380 <panic>
801023be:	66 90                	xchg   %ax,%ax

801023c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023c5:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
801023cc:	00 c0 fe 
  ioapic->reg = reg;
801023cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023d6:	00 00 00 
  return ioapic->data;
801023d9:	8b 15 34 16 11 80    	mov    0x80111634,%edx
801023df:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023e8:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023ee:	0f b6 15 80 17 18 80 	movzbl 0x80181780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023f5:	c1 ee 10             	shr    $0x10,%esi
801023f8:	89 f0                	mov    %esi,%eax
801023fa:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023fd:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102400:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102403:	39 c2                	cmp    %eax,%edx
80102405:	74 16                	je     8010241d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 38 79 10 80       	push   $0x80107938
8010240f:	e8 9c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102414:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010241a:	83 c4 10             	add    $0x10,%esp
{
8010241d:	ba 10 00 00 00       	mov    $0x10,%edx
80102422:	31 c0                	xor    %eax,%eax
80102424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102428:	89 13                	mov    %edx,(%ebx)
8010242a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010242d:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102433:	83 c0 01             	add    $0x1,%eax
80102436:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
8010243c:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
8010243f:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
80102442:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102445:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102447:	8b 1d 34 16 11 80    	mov    0x80111634,%ebx
8010244d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
80102454:	39 c6                	cmp    %eax,%esi
80102456:	7d d0                	jge    80102428 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102458:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010245b:	5b                   	pop    %ebx
8010245c:	5e                   	pop    %esi
8010245d:	5d                   	pop    %ebp
8010245e:	c3                   	ret
8010245f:	90                   	nop

80102460 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102460:	55                   	push   %ebp
  ioapic->reg = reg;
80102461:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
{
80102467:	89 e5                	mov    %esp,%ebp
80102469:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010246c:	8d 50 20             	lea    0x20(%eax),%edx
8010246f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102473:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102475:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010247b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010247e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102481:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102484:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102486:	a1 34 16 11 80       	mov    0x80111634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010248b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010248e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret
80102493:	66 90                	xchg   %ax,%ax
80102495:	66 90                	xchg   %ax,%ax
80102497:	66 90                	xchg   %ax,%ax
80102499:	66 90                	xchg   %ax,%ax
8010249b:	66 90                	xchg   %ax,%ax
8010249d:	66 90                	xchg   %ax,%ax
8010249f:	90                   	nop

801024a0 <incref>:
  struct run *next;
};
struct kmem kmem;
int kref[PHYSTOP / PGSIZE];

void incref(char *pa) {
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	53                   	push   %ebx
801024a4:	83 ec 10             	sub    $0x10,%esp
801024a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&kmem.lock);
801024aa:	68 40 96 14 80       	push   $0x80149640
801024af:	e8 dc 21 00 00       	call   80104690 <acquire>
  kmem.refcount[V2P(pa) / PGSIZE]++;  // Increase ref count
801024b4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  release(&kmem.lock);
801024ba:	83 c4 10             	add    $0x10,%esp
}
801024bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  kmem.refcount[V2P(pa) / PGSIZE]++;  // Increase ref count
801024c0:	c1 e8 0c             	shr    $0xc,%eax
  release(&kmem.lock);
801024c3:	c7 45 08 40 96 14 80 	movl   $0x80149640,0x8(%ebp)
  kmem.refcount[V2P(pa) / PGSIZE]++;  // Increase ref count
801024ca:	83 04 85 78 96 14 80 	addl   $0x1,-0x7feb6988(,%eax,4)
801024d1:	01 
}
801024d2:	c9                   	leave
  release(&kmem.lock);
801024d3:	e9 58 21 00 00       	jmp    80104630 <release>
801024d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801024df:	00 

801024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024f0:	75 76                	jne    80102568 <kfree+0x88>
801024f2:	81 fb d0 54 18 80    	cmp    $0x801854d0,%ebx
801024f8:	72 6e                	jb     80102568 <kfree+0x88>
801024fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102500:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102505:	77 61                	ja     80102568 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102507:	83 ec 04             	sub    $0x4,%esp
8010250a:	68 00 10 00 00       	push   $0x1000
8010250f:	6a 01                	push   $0x1
80102511:	53                   	push   %ebx
80102512:	e8 79 22 00 00       	call   80104790 <memset>

  if(kmem.use_lock)
80102517:	8b 15 74 96 14 80    	mov    0x80149674,%edx
8010251d:	83 c4 10             	add    $0x10,%esp
80102520:	85 d2                	test   %edx,%edx
80102522:	75 1c                	jne    80102540 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102524:	a1 78 16 18 80       	mov    0x80181678,%eax
80102529:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010252b:	a1 74 96 14 80       	mov    0x80149674,%eax
  kmem.freelist = r;
80102530:	89 1d 78 16 18 80    	mov    %ebx,0x80181678
  if(kmem.use_lock)
80102536:	85 c0                	test   %eax,%eax
80102538:	75 1e                	jne    80102558 <kfree+0x78>
    release(&kmem.lock);
}
8010253a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010253d:	c9                   	leave
8010253e:	c3                   	ret
8010253f:	90                   	nop
    acquire(&kmem.lock);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 40 96 14 80       	push   $0x80149640
80102548:	e8 43 21 00 00       	call   80104690 <acquire>
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	eb d2                	jmp    80102524 <kfree+0x44>
80102552:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102558:	c7 45 08 40 96 14 80 	movl   $0x80149640,0x8(%ebp)
}
8010255f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102562:	c9                   	leave
    release(&kmem.lock);
80102563:	e9 c8 20 00 00       	jmp    80104630 <release>
    panic("kfree");
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	68 8c 75 10 80       	push   $0x8010758c
80102570:	e8 0b de ff ff       	call   80100380 <panic>
80102575:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010257c:	00 
8010257d:	8d 76 00             	lea    0x0(%esi),%esi

80102580 <decref>:
void decref(char *pa) {
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
80102584:	53                   	push   %ebx
80102585:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&kmem.lock);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	68 40 96 14 80       	push   $0x80149640
80102590:	e8 fb 20 00 00       	call   80104690 <acquire>
  int ref = --kmem.refcount[V2P(pa) / PGSIZE]; // Decrease ref count
80102595:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010259b:	c1 e8 0c             	shr    $0xc,%eax
8010259e:	83 c0 0c             	add    $0xc,%eax
801025a1:	8b 14 85 48 96 14 80 	mov    -0x7feb69b8(,%eax,4),%edx
801025a8:	8d 72 ff             	lea    -0x1(%edx),%esi
801025ab:	89 34 85 48 96 14 80 	mov    %esi,-0x7feb69b8(,%eax,4)
  release(&kmem.lock);
801025b2:	c7 04 24 40 96 14 80 	movl   $0x80149640,(%esp)
801025b9:	e8 72 20 00 00       	call   80104630 <release>
  if (ref == 0) {
801025be:	83 c4 10             	add    $0x10,%esp
801025c1:	85 f6                	test   %esi,%esi
801025c3:	74 0b                	je     801025d0 <decref+0x50>
}
801025c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c8:	5b                   	pop    %ebx
801025c9:	5e                   	pop    %esi
801025ca:	5d                   	pop    %ebp
801025cb:	c3                   	ret
801025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(pa);  // Free memory when refcount reaches 0
801025d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801025d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d6:	5b                   	pop    %ebx
801025d7:	5e                   	pop    %esi
801025d8:	5d                   	pop    %ebp
    kfree(pa);  // Free memory when refcount reaches 0
801025d9:	e9 02 ff ff ff       	jmp    801024e0 <kfree>
801025de:	66 90                	xchg   %ax,%ax

801025e0 <freerange>:
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	56                   	push   %esi
801025e4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025e5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025eb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025fd:	39 de                	cmp    %ebx,%esi
801025ff:	72 23                	jb     80102624 <freerange+0x44>
80102601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 c3 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <freerange+0x28>
}
80102624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret
8010262b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102630 <kinit2>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	56                   	push   %esi
80102634:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102635:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102638:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010263b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102641:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102647:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010264d:	39 de                	cmp    %ebx,%esi
8010264f:	72 23                	jb     80102674 <kinit2+0x44>
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 73 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 de                	cmp    %ebx,%esi
80102672:	73 e4                	jae    80102658 <kinit2+0x28>
  kmem.use_lock = 1;
80102674:	c7 05 74 96 14 80 01 	movl   $0x1,0x80149674
8010267b:	00 00 00 
}
8010267e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret
80102685:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010268c:	00 
8010268d:	8d 76 00             	lea    0x0(%esi),%esi

80102690 <kinit1>:
{
80102690:	55                   	push   %ebp
80102691:	89 e5                	mov    %esp,%ebp
80102693:	56                   	push   %esi
80102694:	53                   	push   %ebx
80102695:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102698:	83 ec 08             	sub    $0x8,%esp
8010269b:	68 92 75 10 80       	push   $0x80107592
801026a0:	68 40 96 14 80       	push   $0x80149640
801026a5:	e8 f6 1d 00 00       	call   801044a0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026b0:	c7 05 74 96 14 80 00 	movl   $0x0,0x80149674
801026b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026cc:	39 de                	cmp    %ebx,%esi
801026ce:	72 1c                	jb     801026ec <kinit1+0x5c>
    kfree(p);
801026d0:	83 ec 0c             	sub    $0xc,%esp
801026d3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026df:	50                   	push   %eax
801026e0:	e8 fb fd ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026e5:	83 c4 10             	add    $0x10,%esp
801026e8:	39 de                	cmp    %ebx,%esi
801026ea:	73 e4                	jae    801026d0 <kinit1+0x40>
}
801026ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026ef:	5b                   	pop    %ebx
801026f0:	5e                   	pop    %esi
801026f1:	5d                   	pop    %ebp
801026f2:	c3                   	ret
801026f3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026fa:	00 
801026fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102700 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	53                   	push   %ebx
80102704:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102707:	8b 0d 74 96 14 80    	mov    0x80149674,%ecx
8010270d:	85 c9                	test   %ecx,%ecx
8010270f:	75 5f                	jne    80102770 <kalloc+0x70>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102711:	8b 1d 78 16 18 80    	mov    0x80181678,%ebx
  if(r)
80102717:	85 db                	test   %ebx,%ebx
80102719:	0f 84 ab 00 00 00    	je     801027ca <kalloc+0xca>
    kmem.freelist = r->next;
8010271f:	8b 03                	mov    (%ebx),%eax
80102721:	a3 78 16 18 80       	mov    %eax,0x80181678
  if(kmem.use_lock)
    release(&kmem.lock);
  if (r) {
    memset((char*)r, 0, PGSIZE);
80102726:	83 ec 04             	sub    $0x4,%esp
80102729:	68 00 10 00 00       	push   $0x1000
8010272e:	6a 00                	push   $0x0
80102730:	53                   	push   %ebx
80102731:	e8 5a 20 00 00       	call   80104790 <memset>
    acquire(&kmem.lock);
80102736:	c7 04 24 40 96 14 80 	movl   $0x80149640,(%esp)
8010273d:	e8 4e 1f 00 00       	call   80104690 <acquire>
    kmem.refcount[V2P((char*)r) / PGSIZE] = 1;  // Initialize refcount to 1
80102742:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
    release(&kmem.lock);
80102748:	c7 04 24 40 96 14 80 	movl   $0x80149640,(%esp)
    kmem.refcount[V2P((char*)r) / PGSIZE] = 1;  // Initialize refcount to 1
8010274f:	c1 e8 0c             	shr    $0xc,%eax
80102752:	c7 04 85 78 96 14 80 	movl   $0x1,-0x7feb6988(,%eax,4)
80102759:	01 00 00 00 
    release(&kmem.lock);
8010275d:	e8 ce 1e 00 00       	call   80104630 <release>
80102762:	83 c4 10             	add    $0x10,%esp
  }  
  return (char*)r;
}
80102765:	89 d8                	mov    %ebx,%eax
80102767:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276a:	c9                   	leave
8010276b:	c3                   	ret
8010276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102770:	83 ec 0c             	sub    $0xc,%esp
80102773:	68 40 96 14 80       	push   $0x80149640
80102778:	e8 13 1f 00 00       	call   80104690 <acquire>
  r = kmem.freelist;
8010277d:	8b 1d 78 16 18 80    	mov    0x80181678,%ebx
  if(r)
80102783:	83 c4 10             	add    $0x10,%esp
80102786:	85 db                	test   %ebx,%ebx
80102788:	74 26                	je     801027b0 <kalloc+0xb0>
    kmem.freelist = r->next;
8010278a:	8b 03                	mov    (%ebx),%eax
8010278c:	a3 78 16 18 80       	mov    %eax,0x80181678
  if(kmem.use_lock)
80102791:	a1 74 96 14 80       	mov    0x80149674,%eax
80102796:	85 c0                	test   %eax,%eax
80102798:	74 8c                	je     80102726 <kalloc+0x26>
    release(&kmem.lock);
8010279a:	83 ec 0c             	sub    $0xc,%esp
8010279d:	68 40 96 14 80       	push   $0x80149640
801027a2:	e8 89 1e 00 00       	call   80104630 <release>
801027a7:	83 c4 10             	add    $0x10,%esp
801027aa:	e9 77 ff ff ff       	jmp    80102726 <kalloc+0x26>
801027af:	90                   	nop
  if(kmem.use_lock)
801027b0:	8b 15 74 96 14 80    	mov    0x80149674,%edx
801027b6:	85 d2                	test   %edx,%edx
801027b8:	74 10                	je     801027ca <kalloc+0xca>
    release(&kmem.lock);
801027ba:	83 ec 0c             	sub    $0xc,%esp
801027bd:	68 40 96 14 80       	push   $0x80149640
801027c2:	e8 69 1e 00 00       	call   80104630 <release>
801027c7:	83 c4 10             	add    $0x10,%esp
{
801027ca:	31 db                	xor    %ebx,%ebx
801027cc:	eb 97                	jmp    80102765 <kalloc+0x65>
801027ce:	66 90                	xchg   %ax,%ax

801027d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d0:	ba 64 00 00 00       	mov    $0x64,%edx
801027d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027d6:	a8 01                	test   $0x1,%al
801027d8:	0f 84 c2 00 00 00    	je     801028a0 <kbdgetc+0xd0>
{
801027de:	55                   	push   %ebp
801027df:	ba 60 00 00 00       	mov    $0x60,%edx
801027e4:	89 e5                	mov    %esp,%ebp
801027e6:	53                   	push   %ebx
801027e7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027e8:	8b 1d 7c 16 18 80    	mov    0x8018167c,%ebx
  data = inb(KBDATAP);
801027ee:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027f1:	3c e0                	cmp    $0xe0,%al
801027f3:	74 5b                	je     80102850 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801027f5:	89 da                	mov    %ebx,%edx
801027f7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027fa:	84 c0                	test   %al,%al
801027fc:	78 62                	js     80102860 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027fe:	85 d2                	test   %edx,%edx
80102800:	74 09                	je     8010280b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102802:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102805:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102808:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010280b:	0f b6 91 a0 7b 10 80 	movzbl -0x7fef8460(%ecx),%edx
  shift ^= togglecode[data];
80102812:	0f b6 81 a0 7a 10 80 	movzbl -0x7fef8560(%ecx),%eax
  shift |= shiftcode[data];
80102819:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010281b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010281d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010281f:	89 15 7c 16 18 80    	mov    %edx,0x8018167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102825:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102828:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010282b:	8b 04 85 80 7a 10 80 	mov    -0x7fef8580(,%eax,4),%eax
80102832:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102836:	74 0b                	je     80102843 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102838:	8d 50 9f             	lea    -0x61(%eax),%edx
8010283b:	83 fa 19             	cmp    $0x19,%edx
8010283e:	77 48                	ja     80102888 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102840:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102843:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102846:	c9                   	leave
80102847:	c3                   	ret
80102848:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010284f:	00 
    shift |= E0ESC;
80102850:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102853:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102855:	89 1d 7c 16 18 80    	mov    %ebx,0x8018167c
}
8010285b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010285e:	c9                   	leave
8010285f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102860:	83 e0 7f             	and    $0x7f,%eax
80102863:	85 d2                	test   %edx,%edx
80102865:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102868:	0f b6 81 a0 7b 10 80 	movzbl -0x7fef8460(%ecx),%eax
8010286f:	83 c8 40             	or     $0x40,%eax
80102872:	0f b6 c0             	movzbl %al,%eax
80102875:	f7 d0                	not    %eax
80102877:	21 d8                	and    %ebx,%eax
80102879:	a3 7c 16 18 80       	mov    %eax,0x8018167c
    return 0;
8010287e:	31 c0                	xor    %eax,%eax
80102880:	eb d9                	jmp    8010285b <kbdgetc+0x8b>
80102882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102888:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010288b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010288e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102891:	c9                   	leave
      c += 'a' - 'A';
80102892:	83 f9 1a             	cmp    $0x1a,%ecx
80102895:	0f 42 c2             	cmovb  %edx,%eax
}
80102898:	c3                   	ret
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028a5:	c3                   	ret
801028a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801028ad:	00 
801028ae:	66 90                	xchg   %ax,%ax

801028b0 <kbdintr>:

void
kbdintr(void)
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028b6:	68 d0 27 10 80       	push   $0x801027d0
801028bb:	e8 e0 df ff ff       	call   801008a0 <consoleintr>
}
801028c0:	83 c4 10             	add    $0x10,%esp
801028c3:	c9                   	leave
801028c4:	c3                   	ret
801028c5:	66 90                	xchg   %ax,%ax
801028c7:	66 90                	xchg   %ax,%ax
801028c9:	66 90                	xchg   %ax,%ax
801028cb:	66 90                	xchg   %ax,%ax
801028cd:	66 90                	xchg   %ax,%ax
801028cf:	90                   	nop

801028d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028d0:	a1 80 16 18 80       	mov    0x80181680,%eax
801028d5:	85 c0                	test   %eax,%eax
801028d7:	0f 84 c3 00 00 00    	je     801029a0 <lapicinit+0xd0>
  lapic[index] = value;
801028dd:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028e4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ea:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028f1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028fe:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102901:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102904:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010290b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010290e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102911:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102918:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010291b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102925:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102928:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010292b:	8b 50 30             	mov    0x30(%eax),%edx
8010292e:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102934:	75 72                	jne    801029a8 <lapicinit+0xd8>
  lapic[index] = value;
80102936:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010293d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102940:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102943:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010294a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102950:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102957:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010295d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102964:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010296a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102971:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102974:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102977:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010297e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102981:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102988:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010298e:	80 e6 10             	and    $0x10,%dh
80102991:	75 f5                	jne    80102988 <lapicinit+0xb8>
  lapic[index] = value;
80102993:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010299a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029a0:	c3                   	ret
801029a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029a8:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029af:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029b2:	8b 50 20             	mov    0x20(%eax),%edx
}
801029b5:	e9 7c ff ff ff       	jmp    80102936 <lapicinit+0x66>
801029ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029c0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029c0:	a1 80 16 18 80       	mov    0x80181680,%eax
801029c5:	85 c0                	test   %eax,%eax
801029c7:	74 07                	je     801029d0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029c9:	8b 40 20             	mov    0x20(%eax),%eax
801029cc:	c1 e8 18             	shr    $0x18,%eax
801029cf:	c3                   	ret
    return 0;
801029d0:	31 c0                	xor    %eax,%eax
}
801029d2:	c3                   	ret
801029d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029da:	00 
801029db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801029e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029e0:	a1 80 16 18 80       	mov    0x80181680,%eax
801029e5:	85 c0                	test   %eax,%eax
801029e7:	74 0d                	je     801029f6 <lapiceoi+0x16>
  lapic[index] = value;
801029e9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029f6:	c3                   	ret
801029f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029fe:	00 
801029ff:	90                   	nop

80102a00 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a00:	c3                   	ret
80102a01:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102a08:	00 
80102a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a10 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a10:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a11:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a16:	ba 70 00 00 00       	mov    $0x70,%edx
80102a1b:	89 e5                	mov    %esp,%ebp
80102a1d:	53                   	push   %ebx
80102a1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a21:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a24:	ee                   	out    %al,(%dx)
80102a25:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a2f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a30:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102a32:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a35:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a3b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a3d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102a40:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a42:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a45:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a48:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a4e:	a1 80 16 18 80       	mov    0x80181680,%eax
80102a53:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a59:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a5c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a63:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a66:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a69:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a70:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a73:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a76:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a7c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a7f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a85:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a88:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a8e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a91:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a97:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a9d:	c9                   	leave
80102a9e:	c3                   	ret
80102a9f:	90                   	nop

80102aa0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102aa0:	55                   	push   %ebp
80102aa1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102aa6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aab:	89 e5                	mov    %esp,%ebp
80102aad:	57                   	push   %edi
80102aae:	56                   	push   %esi
80102aaf:	53                   	push   %ebx
80102ab0:	83 ec 4c             	sub    $0x4c,%esp
80102ab3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab4:	ba 71 00 00 00       	mov    $0x71,%edx
80102ab9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102aba:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abd:	bf 70 00 00 00       	mov    $0x70,%edi
80102ac2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102ac5:	8d 76 00             	lea    0x0(%esi),%esi
80102ac8:	31 c0                	xor    %eax,%eax
80102aca:	89 fa                	mov    %edi,%edx
80102acc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ad2:	89 ca                	mov    %ecx,%edx
80102ad4:	ec                   	in     (%dx),%al
80102ad5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad8:	89 fa                	mov    %edi,%edx
80102ada:	b8 02 00 00 00       	mov    $0x2,%eax
80102adf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae0:	89 ca                	mov    %ecx,%edx
80102ae2:	ec                   	in     (%dx),%al
80102ae3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae6:	89 fa                	mov    %edi,%edx
80102ae8:	b8 04 00 00 00       	mov    $0x4,%eax
80102aed:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aee:	89 ca                	mov    %ecx,%edx
80102af0:	ec                   	in     (%dx),%al
80102af1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102af4:	89 fa                	mov    %edi,%edx
80102af6:	b8 07 00 00 00       	mov    $0x7,%eax
80102afb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afc:	89 ca                	mov    %ecx,%edx
80102afe:	ec                   	in     (%dx),%al
80102aff:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b02:	89 fa                	mov    %edi,%edx
80102b04:	b8 08 00 00 00       	mov    $0x8,%eax
80102b09:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0a:	89 ca                	mov    %ecx,%edx
80102b0c:	ec                   	in     (%dx),%al
80102b0d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b0f:	89 fa                	mov    %edi,%edx
80102b11:	b8 09 00 00 00       	mov    $0x9,%eax
80102b16:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b17:	89 ca                	mov    %ecx,%edx
80102b19:	ec                   	in     (%dx),%al
80102b1a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b1d:	89 fa                	mov    %edi,%edx
80102b1f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b25:	89 ca                	mov    %ecx,%edx
80102b27:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b28:	84 c0                	test   %al,%al
80102b2a:	78 9c                	js     80102ac8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b2c:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b30:	89 f2                	mov    %esi,%edx
80102b32:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102b35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b38:	89 fa                	mov    %edi,%edx
80102b3a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b3d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b41:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102b44:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b47:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b4b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b4e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b52:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b55:	31 c0                	xor    %eax,%eax
80102b57:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b58:	89 ca                	mov    %ecx,%edx
80102b5a:	ec                   	in     (%dx),%al
80102b5b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5e:	89 fa                	mov    %edi,%edx
80102b60:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b63:	b8 02 00 00 00       	mov    $0x2,%eax
80102b68:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b69:	89 ca                	mov    %ecx,%edx
80102b6b:	ec                   	in     (%dx),%al
80102b6c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b6f:	89 fa                	mov    %edi,%edx
80102b71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b74:	b8 04 00 00 00       	mov    $0x4,%eax
80102b79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7a:	89 ca                	mov    %ecx,%edx
80102b7c:	ec                   	in     (%dx),%al
80102b7d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b80:	89 fa                	mov    %edi,%edx
80102b82:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b85:	b8 07 00 00 00       	mov    $0x7,%eax
80102b8a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b8b:	89 ca                	mov    %ecx,%edx
80102b8d:	ec                   	in     (%dx),%al
80102b8e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b91:	89 fa                	mov    %edi,%edx
80102b93:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b96:	b8 08 00 00 00       	mov    $0x8,%eax
80102b9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9c:	89 ca                	mov    %ecx,%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba2:	89 fa                	mov    %edi,%edx
80102ba4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ba7:	b8 09 00 00 00       	mov    $0x9,%eax
80102bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bad:	89 ca                	mov    %ecx,%edx
80102baf:	ec                   	in     (%dx),%al
80102bb0:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bb3:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bb6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bb9:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102bbc:	6a 18                	push   $0x18
80102bbe:	50                   	push   %eax
80102bbf:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102bc2:	50                   	push   %eax
80102bc3:	e8 08 1c 00 00       	call   801047d0 <memcmp>
80102bc8:	83 c4 10             	add    $0x10,%esp
80102bcb:	85 c0                	test   %eax,%eax
80102bcd:	0f 85 f5 fe ff ff    	jne    80102ac8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102bd3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bda:	89 f0                	mov    %esi,%eax
80102bdc:	84 c0                	test   %al,%al
80102bde:	75 78                	jne    80102c58 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102be0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102be3:	89 c2                	mov    %eax,%edx
80102be5:	83 e0 0f             	and    $0xf,%eax
80102be8:	c1 ea 04             	shr    $0x4,%edx
80102beb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bee:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bf4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bf7:	89 c2                	mov    %eax,%edx
80102bf9:	83 e0 0f             	and    $0xf,%eax
80102bfc:	c1 ea 04             	shr    $0x4,%edx
80102bff:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c02:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c05:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c08:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c0b:	89 c2                	mov    %eax,%edx
80102c0d:	83 e0 0f             	and    $0xf,%eax
80102c10:	c1 ea 04             	shr    $0x4,%edx
80102c13:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c16:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c19:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c1f:	89 c2                	mov    %eax,%edx
80102c21:	83 e0 0f             	and    $0xf,%eax
80102c24:	c1 ea 04             	shr    $0x4,%edx
80102c27:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c2d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c30:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c33:	89 c2                	mov    %eax,%edx
80102c35:	83 e0 0f             	and    $0xf,%eax
80102c38:	c1 ea 04             	shr    $0x4,%edx
80102c3b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c41:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c44:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c47:	89 c2                	mov    %eax,%edx
80102c49:	83 e0 0f             	and    $0xf,%eax
80102c4c:	c1 ea 04             	shr    $0x4,%edx
80102c4f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c52:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c55:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c58:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c5b:	89 03                	mov    %eax,(%ebx)
80102c5d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c60:	89 43 04             	mov    %eax,0x4(%ebx)
80102c63:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c66:	89 43 08             	mov    %eax,0x8(%ebx)
80102c69:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c6c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c6f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c72:	89 43 10             	mov    %eax,0x10(%ebx)
80102c75:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c78:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c7b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c85:	5b                   	pop    %ebx
80102c86:	5e                   	pop    %esi
80102c87:	5f                   	pop    %edi
80102c88:	5d                   	pop    %ebp
80102c89:	c3                   	ret
80102c8a:	66 90                	xchg   %ax,%ax
80102c8c:	66 90                	xchg   %ax,%ax
80102c8e:	66 90                	xchg   %ax,%ax

80102c90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c90:	8b 0d e8 16 18 80    	mov    0x801816e8,%ecx
80102c96:	85 c9                	test   %ecx,%ecx
80102c98:	0f 8e 8a 00 00 00    	jle    80102d28 <install_trans+0x98>
{
80102c9e:	55                   	push   %ebp
80102c9f:	89 e5                	mov    %esp,%ebp
80102ca1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ca2:	31 ff                	xor    %edi,%edi
{
80102ca4:	56                   	push   %esi
80102ca5:	53                   	push   %ebx
80102ca6:	83 ec 0c             	sub    $0xc,%esp
80102ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cb0:	a1 d4 16 18 80       	mov    0x801816d4,%eax
80102cb5:	83 ec 08             	sub    $0x8,%esp
80102cb8:	01 f8                	add    %edi,%eax
80102cba:	83 c0 01             	add    $0x1,%eax
80102cbd:	50                   	push   %eax
80102cbe:	ff 35 e4 16 18 80    	push   0x801816e4
80102cc4:	e8 07 d4 ff ff       	call   801000d0 <bread>
80102cc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ccb:	58                   	pop    %eax
80102ccc:	5a                   	pop    %edx
80102ccd:	ff 34 bd ec 16 18 80 	push   -0x7fe7e914(,%edi,4)
80102cd4:	ff 35 e4 16 18 80    	push   0x801816e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cdd:	e8 ee d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ce2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ce5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ce7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cea:	68 00 02 00 00       	push   $0x200
80102cef:	50                   	push   %eax
80102cf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cf3:	50                   	push   %eax
80102cf4:	e8 27 1b 00 00       	call   80104820 <memmove>
    bwrite(dbuf);  // write dst to disk
80102cf9:	89 1c 24             	mov    %ebx,(%esp)
80102cfc:	e8 af d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d01:	89 34 24             	mov    %esi,(%esp)
80102d04:	e8 e7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d09:	89 1c 24             	mov    %ebx,(%esp)
80102d0c:	e8 df d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d11:	83 c4 10             	add    $0x10,%esp
80102d14:	39 3d e8 16 18 80    	cmp    %edi,0x801816e8
80102d1a:	7f 94                	jg     80102cb0 <install_trans+0x20>
  }
}
80102d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d1f:	5b                   	pop    %ebx
80102d20:	5e                   	pop    %esi
80102d21:	5f                   	pop    %edi
80102d22:	5d                   	pop    %ebp
80102d23:	c3                   	ret
80102d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d28:	c3                   	ret
80102d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d37:	ff 35 d4 16 18 80    	push   0x801816d4
80102d3d:	ff 35 e4 16 18 80    	push   0x801816e4
80102d43:	e8 88 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d4d:	a1 e8 16 18 80       	mov    0x801816e8,%eax
80102d52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d55:	85 c0                	test   %eax,%eax
80102d57:	7e 19                	jle    80102d72 <write_head+0x42>
80102d59:	31 d2                	xor    %edx,%edx
80102d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102d60:	8b 0c 95 ec 16 18 80 	mov    -0x7fe7e914(,%edx,4),%ecx
80102d67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d6b:	83 c2 01             	add    $0x1,%edx
80102d6e:	39 d0                	cmp    %edx,%eax
80102d70:	75 ee                	jne    80102d60 <write_head+0x30>
  }
  bwrite(buf);
80102d72:	83 ec 0c             	sub    $0xc,%esp
80102d75:	53                   	push   %ebx
80102d76:	e8 35 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d7b:	89 1c 24             	mov    %ebx,(%esp)
80102d7e:	e8 6d d4 ff ff       	call   801001f0 <brelse>
}
80102d83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d86:	83 c4 10             	add    $0x10,%esp
80102d89:	c9                   	leave
80102d8a:	c3                   	ret
80102d8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d90 <initlog>:
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 2c             	sub    $0x2c,%esp
80102d97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d9a:	68 97 75 10 80       	push   $0x80107597
80102d9f:	68 a0 16 18 80       	push   $0x801816a0
80102da4:	e8 f7 16 00 00       	call   801044a0 <initlock>
  readsb(dev, &sb);
80102da9:	58                   	pop    %eax
80102daa:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102dad:	5a                   	pop    %edx
80102dae:	50                   	push   %eax
80102daf:	53                   	push   %ebx
80102db0:	e8 8b e7 ff ff       	call   80101540 <readsb>
  log.start = sb.logstart;
80102db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102db8:	59                   	pop    %ecx
  log.dev = dev;
80102db9:	89 1d e4 16 18 80    	mov    %ebx,0x801816e4
  log.size = sb.nlog;
80102dbf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102dc2:	a3 d4 16 18 80       	mov    %eax,0x801816d4
  log.size = sb.nlog;
80102dc7:	89 15 d8 16 18 80    	mov    %edx,0x801816d8
  struct buf *buf = bread(log.dev, log.start);
80102dcd:	5a                   	pop    %edx
80102dce:	50                   	push   %eax
80102dcf:	53                   	push   %ebx
80102dd0:	e8 fb d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102dd5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102dd8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ddb:	89 1d e8 16 18 80    	mov    %ebx,0x801816e8
  for (i = 0; i < log.lh.n; i++) {
80102de1:	85 db                	test   %ebx,%ebx
80102de3:	7e 1d                	jle    80102e02 <initlog+0x72>
80102de5:	31 d2                	xor    %edx,%edx
80102de7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dee:	00 
80102def:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102df0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102df4:	89 0c 95 ec 16 18 80 	mov    %ecx,-0x7fe7e914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dfb:	83 c2 01             	add    $0x1,%edx
80102dfe:	39 d3                	cmp    %edx,%ebx
80102e00:	75 ee                	jne    80102df0 <initlog+0x60>
  brelse(buf);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	50                   	push   %eax
80102e06:	e8 e5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e0b:	e8 80 fe ff ff       	call   80102c90 <install_trans>
  log.lh.n = 0;
80102e10:	c7 05 e8 16 18 80 00 	movl   $0x0,0x801816e8
80102e17:	00 00 00 
  write_head(); // clear the log
80102e1a:	e8 11 ff ff ff       	call   80102d30 <write_head>
}
80102e1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e22:	83 c4 10             	add    $0x10,%esp
80102e25:	c9                   	leave
80102e26:	c3                   	ret
80102e27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e2e:	00 
80102e2f:	90                   	nop

80102e30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e30:	55                   	push   %ebp
80102e31:	89 e5                	mov    %esp,%ebp
80102e33:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e36:	68 a0 16 18 80       	push   $0x801816a0
80102e3b:	e8 50 18 00 00       	call   80104690 <acquire>
80102e40:	83 c4 10             	add    $0x10,%esp
80102e43:	eb 18                	jmp    80102e5d <begin_op+0x2d>
80102e45:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e48:	83 ec 08             	sub    $0x8,%esp
80102e4b:	68 a0 16 18 80       	push   $0x801816a0
80102e50:	68 a0 16 18 80       	push   $0x801816a0
80102e55:	e8 b6 12 00 00       	call   80104110 <sleep>
80102e5a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e5d:	a1 e0 16 18 80       	mov    0x801816e0,%eax
80102e62:	85 c0                	test   %eax,%eax
80102e64:	75 e2                	jne    80102e48 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e66:	a1 dc 16 18 80       	mov    0x801816dc,%eax
80102e6b:	8b 15 e8 16 18 80    	mov    0x801816e8,%edx
80102e71:	83 c0 01             	add    $0x1,%eax
80102e74:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e77:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e7a:	83 fa 1e             	cmp    $0x1e,%edx
80102e7d:	7f c9                	jg     80102e48 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e7f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e82:	a3 dc 16 18 80       	mov    %eax,0x801816dc
      release(&log.lock);
80102e87:	68 a0 16 18 80       	push   $0x801816a0
80102e8c:	e8 9f 17 00 00       	call   80104630 <release>
      break;
    }
  }
}
80102e91:	83 c4 10             	add    $0x10,%esp
80102e94:	c9                   	leave
80102e95:	c3                   	ret
80102e96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e9d:	00 
80102e9e:	66 90                	xchg   %ax,%ax

80102ea0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	57                   	push   %edi
80102ea4:	56                   	push   %esi
80102ea5:	53                   	push   %ebx
80102ea6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ea9:	68 a0 16 18 80       	push   $0x801816a0
80102eae:	e8 dd 17 00 00       	call   80104690 <acquire>
  log.outstanding -= 1;
80102eb3:	a1 dc 16 18 80       	mov    0x801816dc,%eax
  if(log.committing)
80102eb8:	8b 35 e0 16 18 80    	mov    0x801816e0,%esi
80102ebe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ec1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ec4:	89 1d dc 16 18 80    	mov    %ebx,0x801816dc
  if(log.committing)
80102eca:	85 f6                	test   %esi,%esi
80102ecc:	0f 85 22 01 00 00    	jne    80102ff4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ed2:	85 db                	test   %ebx,%ebx
80102ed4:	0f 85 f6 00 00 00    	jne    80102fd0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eda:	c7 05 e0 16 18 80 01 	movl   $0x1,0x801816e0
80102ee1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ee4:	83 ec 0c             	sub    $0xc,%esp
80102ee7:	68 a0 16 18 80       	push   $0x801816a0
80102eec:	e8 3f 17 00 00       	call   80104630 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ef1:	8b 0d e8 16 18 80    	mov    0x801816e8,%ecx
80102ef7:	83 c4 10             	add    $0x10,%esp
80102efa:	85 c9                	test   %ecx,%ecx
80102efc:	7f 42                	jg     80102f40 <end_op+0xa0>
    acquire(&log.lock);
80102efe:	83 ec 0c             	sub    $0xc,%esp
80102f01:	68 a0 16 18 80       	push   $0x801816a0
80102f06:	e8 85 17 00 00       	call   80104690 <acquire>
    log.committing = 0;
80102f0b:	c7 05 e0 16 18 80 00 	movl   $0x0,0x801816e0
80102f12:	00 00 00 
    wakeup(&log);
80102f15:	c7 04 24 a0 16 18 80 	movl   $0x801816a0,(%esp)
80102f1c:	e8 af 12 00 00       	call   801041d0 <wakeup>
    release(&log.lock);
80102f21:	c7 04 24 a0 16 18 80 	movl   $0x801816a0,(%esp)
80102f28:	e8 03 17 00 00       	call   80104630 <release>
80102f2d:	83 c4 10             	add    $0x10,%esp
}
80102f30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f33:	5b                   	pop    %ebx
80102f34:	5e                   	pop    %esi
80102f35:	5f                   	pop    %edi
80102f36:	5d                   	pop    %ebp
80102f37:	c3                   	ret
80102f38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f3f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f40:	a1 d4 16 18 80       	mov    0x801816d4,%eax
80102f45:	83 ec 08             	sub    $0x8,%esp
80102f48:	01 d8                	add    %ebx,%eax
80102f4a:	83 c0 01             	add    $0x1,%eax
80102f4d:	50                   	push   %eax
80102f4e:	ff 35 e4 16 18 80    	push   0x801816e4
80102f54:	e8 77 d1 ff ff       	call   801000d0 <bread>
80102f59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f5b:	58                   	pop    %eax
80102f5c:	5a                   	pop    %edx
80102f5d:	ff 34 9d ec 16 18 80 	push   -0x7fe7e914(,%ebx,4)
80102f64:	ff 35 e4 16 18 80    	push   0x801816e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f6d:	e8 5e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f7a:	68 00 02 00 00       	push   $0x200
80102f7f:	50                   	push   %eax
80102f80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f83:	50                   	push   %eax
80102f84:	e8 97 18 00 00       	call   80104820 <memmove>
    bwrite(to);  // write the log
80102f89:	89 34 24             	mov    %esi,(%esp)
80102f8c:	e8 1f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f91:	89 3c 24             	mov    %edi,(%esp)
80102f94:	e8 57 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f99:	89 34 24             	mov    %esi,(%esp)
80102f9c:	e8 4f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	3b 1d e8 16 18 80    	cmp    0x801816e8,%ebx
80102faa:	7c 94                	jl     80102f40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fac:	e8 7f fd ff ff       	call   80102d30 <write_head>
    install_trans(); // Now install writes to home locations
80102fb1:	e8 da fc ff ff       	call   80102c90 <install_trans>
    log.lh.n = 0;
80102fb6:	c7 05 e8 16 18 80 00 	movl   $0x0,0x801816e8
80102fbd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fc0:	e8 6b fd ff ff       	call   80102d30 <write_head>
80102fc5:	e9 34 ff ff ff       	jmp    80102efe <end_op+0x5e>
80102fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fd0:	83 ec 0c             	sub    $0xc,%esp
80102fd3:	68 a0 16 18 80       	push   $0x801816a0
80102fd8:	e8 f3 11 00 00       	call   801041d0 <wakeup>
  release(&log.lock);
80102fdd:	c7 04 24 a0 16 18 80 	movl   $0x801816a0,(%esp)
80102fe4:	e8 47 16 00 00       	call   80104630 <release>
80102fe9:	83 c4 10             	add    $0x10,%esp
}
80102fec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fef:	5b                   	pop    %ebx
80102ff0:	5e                   	pop    %esi
80102ff1:	5f                   	pop    %edi
80102ff2:	5d                   	pop    %ebp
80102ff3:	c3                   	ret
    panic("log.committing");
80102ff4:	83 ec 0c             	sub    $0xc,%esp
80102ff7:	68 9b 75 10 80       	push   $0x8010759b
80102ffc:	e8 7f d3 ff ff       	call   80100380 <panic>
80103001:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103008:	00 
80103009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103010 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	53                   	push   %ebx
80103014:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103017:	8b 15 e8 16 18 80    	mov    0x801816e8,%edx
{
8010301d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103020:	83 fa 1d             	cmp    $0x1d,%edx
80103023:	7f 7d                	jg     801030a2 <log_write+0x92>
80103025:	a1 d8 16 18 80       	mov    0x801816d8,%eax
8010302a:	83 e8 01             	sub    $0x1,%eax
8010302d:	39 c2                	cmp    %eax,%edx
8010302f:	7d 71                	jge    801030a2 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103031:	a1 dc 16 18 80       	mov    0x801816dc,%eax
80103036:	85 c0                	test   %eax,%eax
80103038:	7e 75                	jle    801030af <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010303a:	83 ec 0c             	sub    $0xc,%esp
8010303d:	68 a0 16 18 80       	push   $0x801816a0
80103042:	e8 49 16 00 00       	call   80104690 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103047:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010304a:	83 c4 10             	add    $0x10,%esp
8010304d:	31 c0                	xor    %eax,%eax
8010304f:	8b 15 e8 16 18 80    	mov    0x801816e8,%edx
80103055:	85 d2                	test   %edx,%edx
80103057:	7f 0e                	jg     80103067 <log_write+0x57>
80103059:	eb 15                	jmp    80103070 <log_write+0x60>
8010305b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103060:	83 c0 01             	add    $0x1,%eax
80103063:	39 c2                	cmp    %eax,%edx
80103065:	74 29                	je     80103090 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103067:	39 0c 85 ec 16 18 80 	cmp    %ecx,-0x7fe7e914(,%eax,4)
8010306e:	75 f0                	jne    80103060 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103070:	89 0c 85 ec 16 18 80 	mov    %ecx,-0x7fe7e914(,%eax,4)
  if (i == log.lh.n)
80103077:	39 c2                	cmp    %eax,%edx
80103079:	74 1c                	je     80103097 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010307b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010307e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103081:	c7 45 08 a0 16 18 80 	movl   $0x801816a0,0x8(%ebp)
}
80103088:	c9                   	leave
  release(&log.lock);
80103089:	e9 a2 15 00 00       	jmp    80104630 <release>
8010308e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103090:	89 0c 95 ec 16 18 80 	mov    %ecx,-0x7fe7e914(,%edx,4)
    log.lh.n++;
80103097:	83 c2 01             	add    $0x1,%edx
8010309a:	89 15 e8 16 18 80    	mov    %edx,0x801816e8
801030a0:	eb d9                	jmp    8010307b <log_write+0x6b>
    panic("too big a transaction");
801030a2:	83 ec 0c             	sub    $0xc,%esp
801030a5:	68 aa 75 10 80       	push   $0x801075aa
801030aa:	e8 d1 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801030af:	83 ec 0c             	sub    $0xc,%esp
801030b2:	68 c0 75 10 80       	push   $0x801075c0
801030b7:	e8 c4 d2 ff ff       	call   80100380 <panic>
801030bc:	66 90                	xchg   %ax,%ax
801030be:	66 90                	xchg   %ax,%ax

801030c0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030c0:	55                   	push   %ebp
801030c1:	89 e5                	mov    %esp,%ebp
801030c3:	53                   	push   %ebx
801030c4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030c7:	e8 64 09 00 00       	call   80103a30 <cpuid>
801030cc:	89 c3                	mov    %eax,%ebx
801030ce:	e8 5d 09 00 00       	call   80103a30 <cpuid>
801030d3:	83 ec 04             	sub    $0x4,%esp
801030d6:	53                   	push   %ebx
801030d7:	50                   	push   %eax
801030d8:	68 db 75 10 80       	push   $0x801075db
801030dd:	e8 ce d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801030e2:	e8 99 29 00 00       	call   80105a80 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030e7:	e8 e4 08 00 00       	call   801039d0 <mycpu>
801030ec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030ee:	b8 01 00 00 00       	mov    $0x1,%eax
801030f3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030fa:	e8 01 0c 00 00       	call   80103d00 <scheduler>
801030ff:	90                   	nop

80103100 <mpenter>:
{
80103100:	55                   	push   %ebp
80103101:	89 e5                	mov    %esp,%ebp
80103103:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103106:	e8 45 3b 00 00       	call   80106c50 <switchkvm>
  seginit();
8010310b:	e8 b0 3a 00 00       	call   80106bc0 <seginit>
  lapicinit();
80103110:	e8 bb f7 ff ff       	call   801028d0 <lapicinit>
  mpmain();
80103115:	e8 a6 ff ff ff       	call   801030c0 <mpmain>
8010311a:	66 90                	xchg   %ax,%ax
8010311c:	66 90                	xchg   %ax,%ax
8010311e:	66 90                	xchg   %ax,%ax

80103120 <main>:
{
80103120:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103124:	83 e4 f0             	and    $0xfffffff0,%esp
80103127:	ff 71 fc             	push   -0x4(%ecx)
8010312a:	55                   	push   %ebp
8010312b:	89 e5                	mov    %esp,%ebp
8010312d:	53                   	push   %ebx
8010312e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010312f:	83 ec 08             	sub    $0x8,%esp
80103132:	68 00 00 40 80       	push   $0x80400000
80103137:	68 d0 54 18 80       	push   $0x801854d0
8010313c:	e8 4f f5 ff ff       	call   80102690 <kinit1>
  kvmalloc();      // kernel page table
80103141:	e8 ca 3f 00 00       	call   80107110 <kvmalloc>
  mpinit();        // detect other processors
80103146:	e8 85 01 00 00       	call   801032d0 <mpinit>
  lapicinit();     // interrupt controller
8010314b:	e8 80 f7 ff ff       	call   801028d0 <lapicinit>
  seginit();       // segment descriptors
80103150:	e8 6b 3a 00 00       	call   80106bc0 <seginit>
  picinit();       // disable pic
80103155:	e8 86 03 00 00       	call   801034e0 <picinit>
  ioapicinit();    // another interrupt controller
8010315a:	e8 61 f2 ff ff       	call   801023c0 <ioapicinit>
  consoleinit();   // console hardware
8010315f:	e8 fc d8 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103164:	e8 c7 2c 00 00       	call   80105e30 <uartinit>
  pinit();         // process table
80103169:	e8 42 08 00 00       	call   801039b0 <pinit>
  tvinit();        // trap vectors
8010316e:	e8 8d 28 00 00       	call   80105a00 <tvinit>
  binit();         // buffer cache
80103173:	e8 c8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103178:	e8 b3 dc ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
8010317d:	e8 1e f0 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103182:	83 c4 0c             	add    $0xc,%esp
80103185:	68 8a 00 00 00       	push   $0x8a
8010318a:	68 8c a4 10 80       	push   $0x8010a48c
8010318f:	68 00 70 00 80       	push   $0x80007000
80103194:	e8 87 16 00 00       	call   80104820 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103199:	83 c4 10             	add    $0x10,%esp
8010319c:	69 05 84 17 18 80 b0 	imul   $0xb0,0x80181784,%eax
801031a3:	00 00 00 
801031a6:	05 a0 17 18 80       	add    $0x801817a0,%eax
801031ab:	3d a0 17 18 80       	cmp    $0x801817a0,%eax
801031b0:	76 7e                	jbe    80103230 <main+0x110>
801031b2:	bb a0 17 18 80       	mov    $0x801817a0,%ebx
801031b7:	eb 20                	jmp    801031d9 <main+0xb9>
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031c0:	69 05 84 17 18 80 b0 	imul   $0xb0,0x80181784,%eax
801031c7:	00 00 00 
801031ca:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031d0:	05 a0 17 18 80       	add    $0x801817a0,%eax
801031d5:	39 c3                	cmp    %eax,%ebx
801031d7:	73 57                	jae    80103230 <main+0x110>
    if(c == mycpu())  // We've started already.
801031d9:	e8 f2 07 00 00       	call   801039d0 <mycpu>
801031de:	39 c3                	cmp    %eax,%ebx
801031e0:	74 de                	je     801031c0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031e2:	e8 19 f5 ff ff       	call   80102700 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031e7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801031ea:	c7 05 f8 6f 00 80 00 	movl   $0x80103100,0x80006ff8
801031f1:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031f4:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801031fb:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031fe:	05 00 10 00 00       	add    $0x1000,%eax
80103203:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103208:	0f b6 03             	movzbl (%ebx),%eax
8010320b:	68 00 70 00 00       	push   $0x7000
80103210:	50                   	push   %eax
80103211:	e8 fa f7 ff ff       	call   80102a10 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103216:	83 c4 10             	add    $0x10,%esp
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103220:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103226:	85 c0                	test   %eax,%eax
80103228:	74 f6                	je     80103220 <main+0x100>
8010322a:	eb 94                	jmp    801031c0 <main+0xa0>
8010322c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103230:	83 ec 08             	sub    $0x8,%esp
80103233:	68 00 00 00 8e       	push   $0x8e000000
80103238:	68 00 00 40 80       	push   $0x80400000
8010323d:	e8 ee f3 ff ff       	call   80102630 <kinit2>
  userinit();      // first user process
80103242:	e8 39 08 00 00       	call   80103a80 <userinit>
  mpmain();        // finish this processor's setup
80103247:	e8 74 fe ff ff       	call   801030c0 <mpmain>
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103255:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010325b:	53                   	push   %ebx
  e = addr+len;
8010325c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010325f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103262:	39 de                	cmp    %ebx,%esi
80103264:	72 10                	jb     80103276 <mpsearch1+0x26>
80103266:	eb 50                	jmp    801032b8 <mpsearch1+0x68>
80103268:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010326f:	00 
80103270:	89 fe                	mov    %edi,%esi
80103272:	39 df                	cmp    %ebx,%edi
80103274:	73 42                	jae    801032b8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103276:	83 ec 04             	sub    $0x4,%esp
80103279:	8d 7e 10             	lea    0x10(%esi),%edi
8010327c:	6a 04                	push   $0x4
8010327e:	68 ef 75 10 80       	push   $0x801075ef
80103283:	56                   	push   %esi
80103284:	e8 47 15 00 00       	call   801047d0 <memcmp>
80103289:	83 c4 10             	add    $0x10,%esp
8010328c:	85 c0                	test   %eax,%eax
8010328e:	75 e0                	jne    80103270 <mpsearch1+0x20>
80103290:	89 f2                	mov    %esi,%edx
80103292:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103298:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010329b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010329e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801032a0:	39 fa                	cmp    %edi,%edx
801032a2:	75 f4                	jne    80103298 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032a4:	84 c0                	test   %al,%al
801032a6:	75 c8                	jne    80103270 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032ab:	89 f0                	mov    %esi,%eax
801032ad:	5b                   	pop    %ebx
801032ae:	5e                   	pop    %esi
801032af:	5f                   	pop    %edi
801032b0:	5d                   	pop    %ebp
801032b1:	c3                   	ret
801032b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032bb:	31 f6                	xor    %esi,%esi
}
801032bd:	5b                   	pop    %ebx
801032be:	89 f0                	mov    %esi,%eax
801032c0:	5e                   	pop    %esi
801032c1:	5f                   	pop    %edi
801032c2:	5d                   	pop    %ebp
801032c3:	c3                   	ret
801032c4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801032cb:	00 
801032cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032d0:	55                   	push   %ebp
801032d1:	89 e5                	mov    %esp,%ebp
801032d3:	57                   	push   %edi
801032d4:	56                   	push   %esi
801032d5:	53                   	push   %ebx
801032d6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032e7:	c1 e0 08             	shl    $0x8,%eax
801032ea:	09 d0                	or     %edx,%eax
801032ec:	c1 e0 04             	shl    $0x4,%eax
801032ef:	75 1b                	jne    8010330c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032f1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032f8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032ff:	c1 e0 08             	shl    $0x8,%eax
80103302:	09 d0                	or     %edx,%eax
80103304:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103307:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010330c:	ba 00 04 00 00       	mov    $0x400,%edx
80103311:	e8 3a ff ff ff       	call   80103250 <mpsearch1>
80103316:	89 c3                	mov    %eax,%ebx
80103318:	85 c0                	test   %eax,%eax
8010331a:	0f 84 58 01 00 00    	je     80103478 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103320:	8b 73 04             	mov    0x4(%ebx),%esi
80103323:	85 f6                	test   %esi,%esi
80103325:	0f 84 3d 01 00 00    	je     80103468 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
8010332b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010332e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103334:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103337:	6a 04                	push   $0x4
80103339:	68 f4 75 10 80       	push   $0x801075f4
8010333e:	50                   	push   %eax
8010333f:	e8 8c 14 00 00       	call   801047d0 <memcmp>
80103344:	83 c4 10             	add    $0x10,%esp
80103347:	85 c0                	test   %eax,%eax
80103349:	0f 85 19 01 00 00    	jne    80103468 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010334f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103356:	3c 01                	cmp    $0x1,%al
80103358:	74 08                	je     80103362 <mpinit+0x92>
8010335a:	3c 04                	cmp    $0x4,%al
8010335c:	0f 85 06 01 00 00    	jne    80103468 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103362:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103369:	66 85 d2             	test   %dx,%dx
8010336c:	74 22                	je     80103390 <mpinit+0xc0>
8010336e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103371:	89 f0                	mov    %esi,%eax
  sum = 0;
80103373:	31 d2                	xor    %edx,%edx
80103375:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103378:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010337f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103382:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103384:	39 f8                	cmp    %edi,%eax
80103386:	75 f0                	jne    80103378 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103388:	84 d2                	test   %dl,%dl
8010338a:	0f 85 d8 00 00 00    	jne    80103468 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103390:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103399:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010339c:	a3 80 16 18 80       	mov    %eax,0x80181680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033a1:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033a8:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801033ae:	01 d7                	add    %edx,%edi
801033b0:	89 fa                	mov    %edi,%edx
  ismp = 1;
801033b2:	bf 01 00 00 00       	mov    $0x1,%edi
801033b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801033be:	00 
801033bf:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033c0:	39 d0                	cmp    %edx,%eax
801033c2:	73 19                	jae    801033dd <mpinit+0x10d>
    switch(*p){
801033c4:	0f b6 08             	movzbl (%eax),%ecx
801033c7:	80 f9 02             	cmp    $0x2,%cl
801033ca:	0f 84 80 00 00 00    	je     80103450 <mpinit+0x180>
801033d0:	77 6e                	ja     80103440 <mpinit+0x170>
801033d2:	84 c9                	test   %cl,%cl
801033d4:	74 3a                	je     80103410 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033d6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033d9:	39 d0                	cmp    %edx,%eax
801033db:	72 e7                	jb     801033c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033dd:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801033e0:	85 ff                	test   %edi,%edi
801033e2:	0f 84 dd 00 00 00    	je     801034c5 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033e8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033ec:	74 15                	je     80103403 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033ee:	b8 70 00 00 00       	mov    $0x70,%eax
801033f3:	ba 22 00 00 00       	mov    $0x22,%edx
801033f8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033f9:	ba 23 00 00 00       	mov    $0x23,%edx
801033fe:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033ff:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103402:	ee                   	out    %al,(%dx)
  }
}
80103403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103406:	5b                   	pop    %ebx
80103407:	5e                   	pop    %esi
80103408:	5f                   	pop    %edi
80103409:	5d                   	pop    %ebp
8010340a:	c3                   	ret
8010340b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103410:	8b 0d 84 17 18 80    	mov    0x80181784,%ecx
80103416:	83 f9 07             	cmp    $0x7,%ecx
80103419:	7f 19                	jg     80103434 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010341b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
80103421:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103425:	83 c1 01             	add    $0x1,%ecx
80103428:	89 0d 84 17 18 80    	mov    %ecx,0x80181784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010342e:	88 9e a0 17 18 80    	mov    %bl,-0x7fe7e860(%esi)
      p += sizeof(struct mpproc);
80103434:	83 c0 14             	add    $0x14,%eax
      continue;
80103437:	eb 87                	jmp    801033c0 <mpinit+0xf0>
80103439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103440:	83 e9 03             	sub    $0x3,%ecx
80103443:	80 f9 01             	cmp    $0x1,%cl
80103446:	76 8e                	jbe    801033d6 <mpinit+0x106>
80103448:	31 ff                	xor    %edi,%edi
8010344a:	e9 71 ff ff ff       	jmp    801033c0 <mpinit+0xf0>
8010344f:	90                   	nop
      ioapicid = ioapic->apicno;
80103450:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103454:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103457:	88 0d 80 17 18 80    	mov    %cl,0x80181780
      continue;
8010345d:	e9 5e ff ff ff       	jmp    801033c0 <mpinit+0xf0>
80103462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103468:	83 ec 0c             	sub    $0xc,%esp
8010346b:	68 f9 75 10 80       	push   $0x801075f9
80103470:	e8 0b cf ff ff       	call   80100380 <panic>
80103475:	8d 76 00             	lea    0x0(%esi),%esi
{
80103478:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010347d:	eb 0b                	jmp    8010348a <mpinit+0x1ba>
8010347f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103480:	89 f3                	mov    %esi,%ebx
80103482:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103488:	74 de                	je     80103468 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010348a:	83 ec 04             	sub    $0x4,%esp
8010348d:	8d 73 10             	lea    0x10(%ebx),%esi
80103490:	6a 04                	push   $0x4
80103492:	68 ef 75 10 80       	push   $0x801075ef
80103497:	53                   	push   %ebx
80103498:	e8 33 13 00 00       	call   801047d0 <memcmp>
8010349d:	83 c4 10             	add    $0x10,%esp
801034a0:	85 c0                	test   %eax,%eax
801034a2:	75 dc                	jne    80103480 <mpinit+0x1b0>
801034a4:	89 da                	mov    %ebx,%edx
801034a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801034ad:	00 
801034ae:	66 90                	xchg   %ax,%ax
    sum += addr[i];
801034b0:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
801034b3:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
801034b6:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801034b8:	39 d6                	cmp    %edx,%esi
801034ba:	75 f4                	jne    801034b0 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034bc:	84 c0                	test   %al,%al
801034be:	75 c0                	jne    80103480 <mpinit+0x1b0>
801034c0:	e9 5b fe ff ff       	jmp    80103320 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801034c5:	83 ec 0c             	sub    $0xc,%esp
801034c8:	68 6c 79 10 80       	push   $0x8010796c
801034cd:	e8 ae ce ff ff       	call   80100380 <panic>
801034d2:	66 90                	xchg   %ax,%ax
801034d4:	66 90                	xchg   %ax,%ax
801034d6:	66 90                	xchg   %ax,%ax
801034d8:	66 90                	xchg   %ax,%ax
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <picinit>:
801034e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034e5:	ba 21 00 00 00       	mov    $0x21,%edx
801034ea:	ee                   	out    %al,(%dx)
801034eb:	ba a1 00 00 00       	mov    $0xa1,%edx
801034f0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034f1:	c3                   	ret
801034f2:	66 90                	xchg   %ax,%ax
801034f4:	66 90                	xchg   %ax,%ax
801034f6:	66 90                	xchg   %ax,%ax
801034f8:	66 90                	xchg   %ax,%ax
801034fa:	66 90                	xchg   %ax,%ax
801034fc:	66 90                	xchg   %ax,%ax
801034fe:	66 90                	xchg   %ax,%ax

80103500 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 0c             	sub    $0xc,%esp
80103509:	8b 75 08             	mov    0x8(%ebp),%esi
8010350c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010350f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103515:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010351b:	e8 30 d9 ff ff       	call   80100e50 <filealloc>
80103520:	89 06                	mov    %eax,(%esi)
80103522:	85 c0                	test   %eax,%eax
80103524:	0f 84 a5 00 00 00    	je     801035cf <pipealloc+0xcf>
8010352a:	e8 21 d9 ff ff       	call   80100e50 <filealloc>
8010352f:	89 07                	mov    %eax,(%edi)
80103531:	85 c0                	test   %eax,%eax
80103533:	0f 84 84 00 00 00    	je     801035bd <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103539:	e8 c2 f1 ff ff       	call   80102700 <kalloc>
8010353e:	89 c3                	mov    %eax,%ebx
80103540:	85 c0                	test   %eax,%eax
80103542:	0f 84 a0 00 00 00    	je     801035e8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103548:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010354f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103552:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103555:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010355c:	00 00 00 
  p->nwrite = 0;
8010355f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103566:	00 00 00 
  p->nread = 0;
80103569:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103570:	00 00 00 
  initlock(&p->lock, "pipe");
80103573:	68 11 76 10 80       	push   $0x80107611
80103578:	50                   	push   %eax
80103579:	e8 22 0f 00 00       	call   801044a0 <initlock>
  (*f0)->type = FD_PIPE;
8010357e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103580:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103583:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103589:	8b 06                	mov    (%esi),%eax
8010358b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010358f:	8b 06                	mov    (%esi),%eax
80103591:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103595:	8b 06                	mov    (%esi),%eax
80103597:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010359a:	8b 07                	mov    (%edi),%eax
8010359c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035a2:	8b 07                	mov    (%edi),%eax
801035a4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035a8:	8b 07                	mov    (%edi),%eax
801035aa:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035ae:	8b 07                	mov    (%edi),%eax
801035b0:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
801035b3:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035b8:	5b                   	pop    %ebx
801035b9:	5e                   	pop    %esi
801035ba:	5f                   	pop    %edi
801035bb:	5d                   	pop    %ebp
801035bc:	c3                   	ret
  if(*f0)
801035bd:	8b 06                	mov    (%esi),%eax
801035bf:	85 c0                	test   %eax,%eax
801035c1:	74 1e                	je     801035e1 <pipealloc+0xe1>
    fileclose(*f0);
801035c3:	83 ec 0c             	sub    $0xc,%esp
801035c6:	50                   	push   %eax
801035c7:	e8 44 d9 ff ff       	call   80100f10 <fileclose>
801035cc:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035cf:	8b 07                	mov    (%edi),%eax
801035d1:	85 c0                	test   %eax,%eax
801035d3:	74 0c                	je     801035e1 <pipealloc+0xe1>
    fileclose(*f1);
801035d5:	83 ec 0c             	sub    $0xc,%esp
801035d8:	50                   	push   %eax
801035d9:	e8 32 d9 ff ff       	call   80100f10 <fileclose>
801035de:	83 c4 10             	add    $0x10,%esp
  return -1;
801035e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035e6:	eb cd                	jmp    801035b5 <pipealloc+0xb5>
  if(*f0)
801035e8:	8b 06                	mov    (%esi),%eax
801035ea:	85 c0                	test   %eax,%eax
801035ec:	75 d5                	jne    801035c3 <pipealloc+0xc3>
801035ee:	eb df                	jmp    801035cf <pipealloc+0xcf>

801035f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035fb:	83 ec 0c             	sub    $0xc,%esp
801035fe:	53                   	push   %ebx
801035ff:	e8 8c 10 00 00       	call   80104690 <acquire>
  if(writable){
80103604:	83 c4 10             	add    $0x10,%esp
80103607:	85 f6                	test   %esi,%esi
80103609:	74 65                	je     80103670 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010360b:	83 ec 0c             	sub    $0xc,%esp
8010360e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103614:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010361b:	00 00 00 
    wakeup(&p->nread);
8010361e:	50                   	push   %eax
8010361f:	e8 ac 0b 00 00       	call   801041d0 <wakeup>
80103624:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103627:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010362d:	85 d2                	test   %edx,%edx
8010362f:	75 0a                	jne    8010363b <pipeclose+0x4b>
80103631:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103637:	85 c0                	test   %eax,%eax
80103639:	74 15                	je     80103650 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010363b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010363e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103641:	5b                   	pop    %ebx
80103642:	5e                   	pop    %esi
80103643:	5d                   	pop    %ebp
    release(&p->lock);
80103644:	e9 e7 0f 00 00       	jmp    80104630 <release>
80103649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	53                   	push   %ebx
80103654:	e8 d7 0f 00 00       	call   80104630 <release>
    kfree((char*)p);
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010365f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103662:	5b                   	pop    %ebx
80103663:	5e                   	pop    %esi
80103664:	5d                   	pop    %ebp
    kfree((char*)p);
80103665:	e9 76 ee ff ff       	jmp    801024e0 <kfree>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103670:	83 ec 0c             	sub    $0xc,%esp
80103673:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103679:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103680:	00 00 00 
    wakeup(&p->nwrite);
80103683:	50                   	push   %eax
80103684:	e8 47 0b 00 00       	call   801041d0 <wakeup>
80103689:	83 c4 10             	add    $0x10,%esp
8010368c:	eb 99                	jmp    80103627 <pipeclose+0x37>
8010368e:	66 90                	xchg   %ax,%ax

80103690 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 28             	sub    $0x28,%esp
80103699:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010369c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010369f:	53                   	push   %ebx
801036a0:	e8 eb 0f 00 00       	call   80104690 <acquire>
  for(i = 0; i < n; i++){
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	85 ff                	test   %edi,%edi
801036aa:	0f 8e ce 00 00 00    	jle    8010377e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b0:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801036b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801036b9:	89 7d 10             	mov    %edi,0x10(%ebp)
801036bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036bf:	8d 34 39             	lea    (%ecx,%edi,1),%esi
801036c2:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036c5:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036cb:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036d1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036d7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801036dd:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801036e0:	0f 85 b6 00 00 00    	jne    8010379c <pipewrite+0x10c>
801036e6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036e9:	eb 3b                	jmp    80103726 <pipewrite+0x96>
801036eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801036f0:	e8 5b 03 00 00       	call   80103a50 <myproc>
801036f5:	8b 48 24             	mov    0x24(%eax),%ecx
801036f8:	85 c9                	test   %ecx,%ecx
801036fa:	75 34                	jne    80103730 <pipewrite+0xa0>
      wakeup(&p->nread);
801036fc:	83 ec 0c             	sub    $0xc,%esp
801036ff:	56                   	push   %esi
80103700:	e8 cb 0a 00 00       	call   801041d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103705:	58                   	pop    %eax
80103706:	5a                   	pop    %edx
80103707:	53                   	push   %ebx
80103708:	57                   	push   %edi
80103709:	e8 02 0a 00 00       	call   80104110 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010370e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103714:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010371a:	83 c4 10             	add    $0x10,%esp
8010371d:	05 00 02 00 00       	add    $0x200,%eax
80103722:	39 c2                	cmp    %eax,%edx
80103724:	75 2a                	jne    80103750 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103726:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010372c:	85 c0                	test   %eax,%eax
8010372e:	75 c0                	jne    801036f0 <pipewrite+0x60>
        release(&p->lock);
80103730:	83 ec 0c             	sub    $0xc,%esp
80103733:	53                   	push   %ebx
80103734:	e8 f7 0e 00 00       	call   80104630 <release>
        return -1;
80103739:	83 c4 10             	add    $0x10,%esp
8010373c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103741:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103744:	5b                   	pop    %ebx
80103745:	5e                   	pop    %esi
80103746:	5f                   	pop    %edi
80103747:	5d                   	pop    %ebp
80103748:	c3                   	ret
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103750:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103753:	8d 42 01             	lea    0x1(%edx),%eax
80103756:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010375c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010375f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103768:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010376c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103770:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103773:	39 c1                	cmp    %eax,%ecx
80103775:	0f 85 50 ff ff ff    	jne    801036cb <pipewrite+0x3b>
8010377b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010377e:	83 ec 0c             	sub    $0xc,%esp
80103781:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103787:	50                   	push   %eax
80103788:	e8 43 0a 00 00       	call   801041d0 <wakeup>
  release(&p->lock);
8010378d:	89 1c 24             	mov    %ebx,(%esp)
80103790:	e8 9b 0e 00 00       	call   80104630 <release>
  return n;
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	89 f8                	mov    %edi,%eax
8010379a:	eb a5                	jmp    80103741 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010379c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010379f:	eb b2                	jmp    80103753 <pipewrite+0xc3>
801037a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801037a8:	00 
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	57                   	push   %edi
801037b4:	56                   	push   %esi
801037b5:	53                   	push   %ebx
801037b6:	83 ec 18             	sub    $0x18,%esp
801037b9:	8b 75 08             	mov    0x8(%ebp),%esi
801037bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037bf:	56                   	push   %esi
801037c0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037c6:	e8 c5 0e 00 00       	call   80104690 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037cb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d1:	83 c4 10             	add    $0x10,%esp
801037d4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037da:	74 2f                	je     8010380b <piperead+0x5b>
801037dc:	eb 37                	jmp    80103815 <piperead+0x65>
801037de:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037e0:	e8 6b 02 00 00       	call   80103a50 <myproc>
801037e5:	8b 40 24             	mov    0x24(%eax),%eax
801037e8:	85 c0                	test   %eax,%eax
801037ea:	0f 85 80 00 00 00    	jne    80103870 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037f0:	83 ec 08             	sub    $0x8,%esp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
801037f5:	e8 16 09 00 00       	call   80104110 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fa:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103800:	83 c4 10             	add    $0x10,%esp
80103803:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103809:	75 0a                	jne    80103815 <piperead+0x65>
8010380b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103811:	85 d2                	test   %edx,%edx
80103813:	75 cb                	jne    801037e0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103815:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103818:	31 db                	xor    %ebx,%ebx
8010381a:	85 c9                	test   %ecx,%ecx
8010381c:	7f 26                	jg     80103844 <piperead+0x94>
8010381e:	eb 2c                	jmp    8010384c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103820:	8d 48 01             	lea    0x1(%eax),%ecx
80103823:	25 ff 01 00 00       	and    $0x1ff,%eax
80103828:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010382e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103833:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103836:	83 c3 01             	add    $0x1,%ebx
80103839:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010383c:	74 0e                	je     8010384c <piperead+0x9c>
8010383e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103844:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010384a:	75 d4                	jne    80103820 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010384c:	83 ec 0c             	sub    $0xc,%esp
8010384f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103855:	50                   	push   %eax
80103856:	e8 75 09 00 00       	call   801041d0 <wakeup>
  release(&p->lock);
8010385b:	89 34 24             	mov    %esi,(%esp)
8010385e:	e8 cd 0d 00 00       	call   80104630 <release>
  return i;
80103863:	83 c4 10             	add    $0x10,%esp
}
80103866:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103869:	89 d8                	mov    %ebx,%eax
8010386b:	5b                   	pop    %ebx
8010386c:	5e                   	pop    %esi
8010386d:	5f                   	pop    %edi
8010386e:	5d                   	pop    %ebp
8010386f:	c3                   	ret
      release(&p->lock);
80103870:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103873:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103878:	56                   	push   %esi
80103879:	e8 b2 0d 00 00       	call   80104630 <release>
      return -1;
8010387e:	83 c4 10             	add    $0x10,%esp
}
80103881:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103884:	89 d8                	mov    %ebx,%eax
80103886:	5b                   	pop    %ebx
80103887:	5e                   	pop    %esi
80103888:	5f                   	pop    %edi
80103889:	5d                   	pop    %ebp
8010388a:	c3                   	ret
8010388b:	66 90                	xchg   %ax,%ax
8010388d:	66 90                	xchg   %ax,%ax
8010388f:	90                   	nop

80103890 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103894:	bb 54 1d 18 80       	mov    $0x80181d54,%ebx
{
80103899:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010389c:	68 20 1d 18 80       	push   $0x80181d20
801038a1:	e8 ea 0d 00 00       	call   80104690 <acquire>
801038a6:	83 c4 10             	add    $0x10,%esp
801038a9:	eb 10                	jmp    801038bb <allocproc+0x2b>
801038ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038b0:	83 c3 7c             	add    $0x7c,%ebx
801038b3:	81 fb 54 3c 18 80    	cmp    $0x80183c54,%ebx
801038b9:	74 75                	je     80103930 <allocproc+0xa0>
    if(p->state == UNUSED)
801038bb:	8b 43 0c             	mov    0xc(%ebx),%eax
801038be:	85 c0                	test   %eax,%eax
801038c0:	75 ee                	jne    801038b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038c2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801038c7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038ca:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038d1:	89 43 10             	mov    %eax,0x10(%ebx)
801038d4:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801038d7:	68 20 1d 18 80       	push   $0x80181d20
  p->pid = nextpid++;
801038dc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801038e2:	e8 49 0d 00 00       	call   80104630 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038e7:	e8 14 ee ff ff       	call   80102700 <kalloc>
801038ec:	83 c4 10             	add    $0x10,%esp
801038ef:	89 43 08             	mov    %eax,0x8(%ebx)
801038f2:	85 c0                	test   %eax,%eax
801038f4:	74 53                	je     80103949 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038f6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038fc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038ff:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103904:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103907:	c7 40 14 f2 59 10 80 	movl   $0x801059f2,0x14(%eax)
  p->context = (struct context*)sp;
8010390e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103911:	6a 14                	push   $0x14
80103913:	6a 00                	push   $0x0
80103915:	50                   	push   %eax
80103916:	e8 75 0e 00 00       	call   80104790 <memset>
  p->context->eip = (uint)forkret;
8010391b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010391e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103921:	c7 40 10 60 39 10 80 	movl   $0x80103960,0x10(%eax)
}
80103928:	89 d8                	mov    %ebx,%eax
8010392a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010392d:	c9                   	leave
8010392e:	c3                   	ret
8010392f:	90                   	nop
  release(&ptable.lock);
80103930:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103933:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103935:	68 20 1d 18 80       	push   $0x80181d20
8010393a:	e8 f1 0c 00 00       	call   80104630 <release>
  return 0;
8010393f:	83 c4 10             	add    $0x10,%esp
}
80103942:	89 d8                	mov    %ebx,%eax
80103944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103947:	c9                   	leave
80103948:	c3                   	ret
    p->state = UNUSED;
80103949:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103950:	31 db                	xor    %ebx,%ebx
80103952:	eb ee                	jmp    80103942 <allocproc+0xb2>
80103954:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010395b:	00 
8010395c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103960 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103966:	68 20 1d 18 80       	push   $0x80181d20
8010396b:	e8 c0 0c 00 00       	call   80104630 <release>

  if (first) {
80103970:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103975:	83 c4 10             	add    $0x10,%esp
80103978:	85 c0                	test   %eax,%eax
8010397a:	75 04                	jne    80103980 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010397c:	c9                   	leave
8010397d:	c3                   	ret
8010397e:	66 90                	xchg   %ax,%ax
    first = 0;
80103980:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103987:	00 00 00 
    iinit(ROOTDEV);
8010398a:	83 ec 0c             	sub    $0xc,%esp
8010398d:	6a 01                	push   $0x1
8010398f:	e8 ec db ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
80103994:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010399b:	e8 f0 f3 ff ff       	call   80102d90 <initlog>
}
801039a0:	83 c4 10             	add    $0x10,%esp
801039a3:	c9                   	leave
801039a4:	c3                   	ret
801039a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801039ac:	00 
801039ad:	8d 76 00             	lea    0x0(%esi),%esi

801039b0 <pinit>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039b6:	68 16 76 10 80       	push   $0x80107616
801039bb:	68 20 1d 18 80       	push   $0x80181d20
801039c0:	e8 db 0a 00 00       	call   801044a0 <initlock>
}
801039c5:	83 c4 10             	add    $0x10,%esp
801039c8:	c9                   	leave
801039c9:	c3                   	ret
801039ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039d0 <mycpu>:
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	56                   	push   %esi
801039d4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039d5:	9c                   	pushf
801039d6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039d7:	f6 c4 02             	test   $0x2,%ah
801039da:	75 46                	jne    80103a22 <mycpu+0x52>
  apicid = lapicid();
801039dc:	e8 df ef ff ff       	call   801029c0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039e1:	8b 35 84 17 18 80    	mov    0x80181784,%esi
801039e7:	85 f6                	test   %esi,%esi
801039e9:	7e 2a                	jle    80103a15 <mycpu+0x45>
801039eb:	31 d2                	xor    %edx,%edx
801039ed:	eb 08                	jmp    801039f7 <mycpu+0x27>
801039ef:	90                   	nop
801039f0:	83 c2 01             	add    $0x1,%edx
801039f3:	39 f2                	cmp    %esi,%edx
801039f5:	74 1e                	je     80103a15 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039f7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039fd:	0f b6 99 a0 17 18 80 	movzbl -0x7fe7e860(%ecx),%ebx
80103a04:	39 c3                	cmp    %eax,%ebx
80103a06:	75 e8                	jne    801039f0 <mycpu+0x20>
}
80103a08:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a0b:	8d 81 a0 17 18 80    	lea    -0x7fe7e860(%ecx),%eax
}
80103a11:	5b                   	pop    %ebx
80103a12:	5e                   	pop    %esi
80103a13:	5d                   	pop    %ebp
80103a14:	c3                   	ret
  panic("unknown apicid\n");
80103a15:	83 ec 0c             	sub    $0xc,%esp
80103a18:	68 1d 76 10 80       	push   $0x8010761d
80103a1d:	e8 5e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a22:	83 ec 0c             	sub    $0xc,%esp
80103a25:	68 8c 79 10 80       	push   $0x8010798c
80103a2a:	e8 51 c9 ff ff       	call   80100380 <panic>
80103a2f:	90                   	nop

80103a30 <cpuid>:
cpuid() {
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a36:	e8 95 ff ff ff       	call   801039d0 <mycpu>
}
80103a3b:	c9                   	leave
  return mycpu()-cpus;
80103a3c:	2d a0 17 18 80       	sub    $0x801817a0,%eax
80103a41:	c1 f8 04             	sar    $0x4,%eax
80103a44:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a4a:	c3                   	ret
80103a4b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a50 <myproc>:
myproc(void) {
80103a50:	55                   	push   %ebp
80103a51:	89 e5                	mov    %esp,%ebp
80103a53:	53                   	push   %ebx
80103a54:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a57:	e8 e4 0a 00 00       	call   80104540 <pushcli>
  c = mycpu();
80103a5c:	e8 6f ff ff ff       	call   801039d0 <mycpu>
  p = c->proc;
80103a61:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a67:	e8 24 0b 00 00       	call   80104590 <popcli>
}
80103a6c:	89 d8                	mov    %ebx,%eax
80103a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a71:	c9                   	leave
80103a72:	c3                   	ret
80103a73:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a7a:	00 
80103a7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a80 <userinit>:
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	53                   	push   %ebx
80103a84:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a87:	e8 04 fe ff ff       	call   80103890 <allocproc>
80103a8c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a8e:	a3 54 3c 18 80       	mov    %eax,0x80183c54
  if((p->pgdir = setupkvm()) == 0)
80103a93:	e8 f8 35 00 00       	call   80107090 <setupkvm>
80103a98:	89 43 04             	mov    %eax,0x4(%ebx)
80103a9b:	85 c0                	test   %eax,%eax
80103a9d:	0f 84 bd 00 00 00    	je     80103b60 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103aa3:	83 ec 04             	sub    $0x4,%esp
80103aa6:	68 2c 00 00 00       	push   $0x2c
80103aab:	68 60 a4 10 80       	push   $0x8010a460
80103ab0:	50                   	push   %eax
80103ab1:	e8 ba 32 00 00       	call   80106d70 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ab6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ab9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103abf:	6a 4c                	push   $0x4c
80103ac1:	6a 00                	push   $0x0
80103ac3:	ff 73 18             	push   0x18(%ebx)
80103ac6:	e8 c5 0c 00 00       	call   80104790 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103acb:	8b 43 18             	mov    0x18(%ebx),%eax
80103ace:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ad3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ad6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103adb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103adf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ae6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103aed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103af1:	8b 43 18             	mov    0x18(%ebx),%eax
80103af4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103af8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103afc:	8b 43 18             	mov    0x18(%ebx),%eax
80103aff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b06:	8b 43 18             	mov    0x18(%ebx),%eax
80103b09:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b10:	8b 43 18             	mov    0x18(%ebx),%eax
80103b13:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b1a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b1d:	6a 10                	push   $0x10
80103b1f:	68 46 76 10 80       	push   $0x80107646
80103b24:	50                   	push   %eax
80103b25:	e8 16 0e 00 00       	call   80104940 <safestrcpy>
  p->cwd = namei("/");
80103b2a:	c7 04 24 4f 76 10 80 	movl   $0x8010764f,(%esp)
80103b31:	e8 4a e5 ff ff       	call   80102080 <namei>
80103b36:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b39:	c7 04 24 20 1d 18 80 	movl   $0x80181d20,(%esp)
80103b40:	e8 4b 0b 00 00       	call   80104690 <acquire>
  p->state = RUNNABLE;
80103b45:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b4c:	c7 04 24 20 1d 18 80 	movl   $0x80181d20,(%esp)
80103b53:	e8 d8 0a 00 00       	call   80104630 <release>
}
80103b58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b5b:	83 c4 10             	add    $0x10,%esp
80103b5e:	c9                   	leave
80103b5f:	c3                   	ret
    panic("userinit: out of memory?");
80103b60:	83 ec 0c             	sub    $0xc,%esp
80103b63:	68 2d 76 10 80       	push   $0x8010762d
80103b68:	e8 13 c8 ff ff       	call   80100380 <panic>
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi

80103b70 <growproc>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	56                   	push   %esi
80103b74:	53                   	push   %ebx
80103b75:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b78:	e8 c3 09 00 00       	call   80104540 <pushcli>
  c = mycpu();
80103b7d:	e8 4e fe ff ff       	call   801039d0 <mycpu>
  p = c->proc;
80103b82:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b88:	e8 03 0a 00 00       	call   80104590 <popcli>
  sz = curproc->sz;
80103b8d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b8f:	85 f6                	test   %esi,%esi
80103b91:	7f 1d                	jg     80103bb0 <growproc+0x40>
  } else if(n < 0){
80103b93:	75 3b                	jne    80103bd0 <growproc+0x60>
  switchuvm(curproc);
80103b95:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b98:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b9a:	53                   	push   %ebx
80103b9b:	e8 c0 30 00 00       	call   80106c60 <switchuvm>
  return 0;
80103ba0:	83 c4 10             	add    $0x10,%esp
80103ba3:	31 c0                	xor    %eax,%eax
}
80103ba5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ba8:	5b                   	pop    %ebx
80103ba9:	5e                   	pop    %esi
80103baa:	5d                   	pop    %ebp
80103bab:	c3                   	ret
80103bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bb0:	83 ec 04             	sub    $0x4,%esp
80103bb3:	01 c6                	add    %eax,%esi
80103bb5:	56                   	push   %esi
80103bb6:	50                   	push   %eax
80103bb7:	ff 73 04             	push   0x4(%ebx)
80103bba:	e8 01 33 00 00       	call   80106ec0 <allocuvm>
80103bbf:	83 c4 10             	add    $0x10,%esp
80103bc2:	85 c0                	test   %eax,%eax
80103bc4:	75 cf                	jne    80103b95 <growproc+0x25>
      return -1;
80103bc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bcb:	eb d8                	jmp    80103ba5 <growproc+0x35>
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bd0:	83 ec 04             	sub    $0x4,%esp
80103bd3:	01 c6                	add    %eax,%esi
80103bd5:	56                   	push   %esi
80103bd6:	50                   	push   %eax
80103bd7:	ff 73 04             	push   0x4(%ebx)
80103bda:	e8 01 34 00 00       	call   80106fe0 <deallocuvm>
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	85 c0                	test   %eax,%eax
80103be4:	75 af                	jne    80103b95 <growproc+0x25>
80103be6:	eb de                	jmp    80103bc6 <growproc+0x56>
80103be8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bef:	00 

80103bf0 <fork>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bf9:	e8 42 09 00 00       	call   80104540 <pushcli>
  c = mycpu();
80103bfe:	e8 cd fd ff ff       	call   801039d0 <mycpu>
  p = c->proc;
80103c03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c09:	e8 82 09 00 00       	call   80104590 <popcli>
  if((np = allocproc()) == 0){
80103c0e:	e8 7d fc ff ff       	call   80103890 <allocproc>
80103c13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c16:	85 c0                	test   %eax,%eax
80103c18:	0f 84 d6 00 00 00    	je     80103cf4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c1e:	83 ec 08             	sub    $0x8,%esp
80103c21:	ff 33                	push   (%ebx)
80103c23:	89 c7                	mov    %eax,%edi
80103c25:	ff 73 04             	push   0x4(%ebx)
80103c28:	e8 53 35 00 00       	call   80107180 <copyuvm>
80103c2d:	83 c4 10             	add    $0x10,%esp
80103c30:	89 47 04             	mov    %eax,0x4(%edi)
80103c33:	85 c0                	test   %eax,%eax
80103c35:	0f 84 9a 00 00 00    	je     80103cd5 <fork+0xe5>
  np->sz = curproc->sz;
80103c3b:	8b 03                	mov    (%ebx),%eax
80103c3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c40:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c42:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c45:	89 c8                	mov    %ecx,%eax
80103c47:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c4a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c4f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c54:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c56:	8b 40 18             	mov    0x18(%eax),%eax
80103c59:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c64:	85 c0                	test   %eax,%eax
80103c66:	74 13                	je     80103c7b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c68:	83 ec 0c             	sub    $0xc,%esp
80103c6b:	50                   	push   %eax
80103c6c:	e8 4f d2 ff ff       	call   80100ec0 <filedup>
80103c71:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c74:	83 c4 10             	add    $0x10,%esp
80103c77:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c7b:	83 c6 01             	add    $0x1,%esi
80103c7e:	83 fe 10             	cmp    $0x10,%esi
80103c81:	75 dd                	jne    80103c60 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c83:	83 ec 0c             	sub    $0xc,%esp
80103c86:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c89:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c8c:	e8 df da ff ff       	call   80101770 <idup>
80103c91:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c94:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c97:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c9a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c9d:	6a 10                	push   $0x10
80103c9f:	53                   	push   %ebx
80103ca0:	50                   	push   %eax
80103ca1:	e8 9a 0c 00 00       	call   80104940 <safestrcpy>
  pid = np->pid;
80103ca6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ca9:	c7 04 24 20 1d 18 80 	movl   $0x80181d20,(%esp)
80103cb0:	e8 db 09 00 00       	call   80104690 <acquire>
  np->state = RUNNABLE;
80103cb5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103cbc:	c7 04 24 20 1d 18 80 	movl   $0x80181d20,(%esp)
80103cc3:	e8 68 09 00 00       	call   80104630 <release>
  return pid;
80103cc8:	83 c4 10             	add    $0x10,%esp
}
80103ccb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cce:	89 d8                	mov    %ebx,%eax
80103cd0:	5b                   	pop    %ebx
80103cd1:	5e                   	pop    %esi
80103cd2:	5f                   	pop    %edi
80103cd3:	5d                   	pop    %ebp
80103cd4:	c3                   	ret
    kfree(np->kstack);
80103cd5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cd8:	83 ec 0c             	sub    $0xc,%esp
80103cdb:	ff 73 08             	push   0x8(%ebx)
80103cde:	e8 fd e7 ff ff       	call   801024e0 <kfree>
    np->kstack = 0;
80103ce3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cea:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103ced:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103cf4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103cf9:	eb d0                	jmp    80103ccb <fork+0xdb>
80103cfb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103d00 <scheduler>:
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d09:	e8 c2 fc ff ff       	call   801039d0 <mycpu>
  c->proc = 0;
80103d0e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d15:	00 00 00 
  struct cpu *c = mycpu();
80103d18:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d1a:	8d 78 04             	lea    0x4(%eax),%edi
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d20:	fb                   	sti
    acquire(&ptable.lock);
80103d21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d24:	bb 54 1d 18 80       	mov    $0x80181d54,%ebx
    acquire(&ptable.lock);
80103d29:	68 20 1d 18 80       	push   $0x80181d20
80103d2e:	e8 5d 09 00 00       	call   80104690 <acquire>
80103d33:	83 c4 10             	add    $0x10,%esp
80103d36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d3d:	00 
80103d3e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d44:	75 33                	jne    80103d79 <scheduler+0x79>
      switchuvm(p);
80103d46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d4f:	53                   	push   %ebx
80103d50:	e8 0b 2f 00 00       	call   80106c60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d55:	58                   	pop    %eax
80103d56:	5a                   	pop    %edx
80103d57:	ff 73 1c             	push   0x1c(%ebx)
80103d5a:	57                   	push   %edi
      p->state = RUNNING;
80103d5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d62:	e8 34 0c 00 00       	call   8010499b <swtch>
      switchkvm();
80103d67:	e8 e4 2e 00 00       	call   80106c50 <switchkvm>
      c->proc = 0;
80103d6c:	83 c4 10             	add    $0x10,%esp
80103d6f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d76:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d79:	83 c3 7c             	add    $0x7c,%ebx
80103d7c:	81 fb 54 3c 18 80    	cmp    $0x80183c54,%ebx
80103d82:	75 bc                	jne    80103d40 <scheduler+0x40>
    release(&ptable.lock);
80103d84:	83 ec 0c             	sub    $0xc,%esp
80103d87:	68 20 1d 18 80       	push   $0x80181d20
80103d8c:	e8 9f 08 00 00       	call   80104630 <release>
    sti();
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	eb 8a                	jmp    80103d20 <scheduler+0x20>
80103d96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d9d:	00 
80103d9e:	66 90                	xchg   %ax,%ax

80103da0 <sched>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	56                   	push   %esi
80103da4:	53                   	push   %ebx
  pushcli();
80103da5:	e8 96 07 00 00       	call   80104540 <pushcli>
  c = mycpu();
80103daa:	e8 21 fc ff ff       	call   801039d0 <mycpu>
  p = c->proc;
80103daf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db5:	e8 d6 07 00 00       	call   80104590 <popcli>
  if(!holding(&ptable.lock))
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 20 1d 18 80       	push   $0x80181d20
80103dc2:	e8 29 08 00 00       	call   801045f0 <holding>
80103dc7:	83 c4 10             	add    $0x10,%esp
80103dca:	85 c0                	test   %eax,%eax
80103dcc:	74 4f                	je     80103e1d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dce:	e8 fd fb ff ff       	call   801039d0 <mycpu>
80103dd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dda:	75 68                	jne    80103e44 <sched+0xa4>
  if(p->state == RUNNING)
80103ddc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103de0:	74 55                	je     80103e37 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103de2:	9c                   	pushf
80103de3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103de4:	f6 c4 02             	test   $0x2,%ah
80103de7:	75 41                	jne    80103e2a <sched+0x8a>
  intena = mycpu()->intena;
80103de9:	e8 e2 fb ff ff       	call   801039d0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103df1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103df7:	e8 d4 fb ff ff       	call   801039d0 <mycpu>
80103dfc:	83 ec 08             	sub    $0x8,%esp
80103dff:	ff 70 04             	push   0x4(%eax)
80103e02:	53                   	push   %ebx
80103e03:	e8 93 0b 00 00       	call   8010499b <swtch>
  mycpu()->intena = intena;
80103e08:	e8 c3 fb ff ff       	call   801039d0 <mycpu>
}
80103e0d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e10:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e19:	5b                   	pop    %ebx
80103e1a:	5e                   	pop    %esi
80103e1b:	5d                   	pop    %ebp
80103e1c:	c3                   	ret
    panic("sched ptable.lock");
80103e1d:	83 ec 0c             	sub    $0xc,%esp
80103e20:	68 51 76 10 80       	push   $0x80107651
80103e25:	e8 56 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	68 7d 76 10 80       	push   $0x8010767d
80103e32:	e8 49 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e37:	83 ec 0c             	sub    $0xc,%esp
80103e3a:	68 6f 76 10 80       	push   $0x8010766f
80103e3f:	e8 3c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e44:	83 ec 0c             	sub    $0xc,%esp
80103e47:	68 63 76 10 80       	push   $0x80107663
80103e4c:	e8 2f c5 ff ff       	call   80100380 <panic>
80103e51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e58:	00 
80103e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e60 <exit>:
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	56                   	push   %esi
80103e65:	53                   	push   %ebx
80103e66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e69:	e8 e2 fb ff ff       	call   80103a50 <myproc>
  if(curproc == initproc)
80103e6e:	39 05 54 3c 18 80    	cmp    %eax,0x80183c54
80103e74:	0f 84 fd 00 00 00    	je     80103f77 <exit+0x117>
80103e7a:	89 c3                	mov    %eax,%ebx
80103e7c:	8d 70 28             	lea    0x28(%eax),%esi
80103e7f:	8d 78 68             	lea    0x68(%eax),%edi
80103e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e88:	8b 06                	mov    (%esi),%eax
80103e8a:	85 c0                	test   %eax,%eax
80103e8c:	74 12                	je     80103ea0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e8e:	83 ec 0c             	sub    $0xc,%esp
80103e91:	50                   	push   %eax
80103e92:	e8 79 d0 ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
80103e97:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e9d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ea0:	83 c6 04             	add    $0x4,%esi
80103ea3:	39 f7                	cmp    %esi,%edi
80103ea5:	75 e1                	jne    80103e88 <exit+0x28>
  begin_op();
80103ea7:	e8 84 ef ff ff       	call   80102e30 <begin_op>
  iput(curproc->cwd);
80103eac:	83 ec 0c             	sub    $0xc,%esp
80103eaf:	ff 73 68             	push   0x68(%ebx)
80103eb2:	e8 19 da ff ff       	call   801018d0 <iput>
  end_op();
80103eb7:	e8 e4 ef ff ff       	call   80102ea0 <end_op>
  curproc->cwd = 0;
80103ebc:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103ec3:	c7 04 24 20 1d 18 80 	movl   $0x80181d20,(%esp)
80103eca:	e8 c1 07 00 00       	call   80104690 <acquire>
  wakeup1(curproc->parent);
80103ecf:	8b 53 14             	mov    0x14(%ebx),%edx
80103ed2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ed5:	b8 54 1d 18 80       	mov    $0x80181d54,%eax
80103eda:	eb 0e                	jmp    80103eea <exit+0x8a>
80103edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ee0:	83 c0 7c             	add    $0x7c,%eax
80103ee3:	3d 54 3c 18 80       	cmp    $0x80183c54,%eax
80103ee8:	74 1c                	je     80103f06 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103eea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eee:	75 f0                	jne    80103ee0 <exit+0x80>
80103ef0:	3b 50 20             	cmp    0x20(%eax),%edx
80103ef3:	75 eb                	jne    80103ee0 <exit+0x80>
      p->state = RUNNABLE;
80103ef5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103efc:	83 c0 7c             	add    $0x7c,%eax
80103eff:	3d 54 3c 18 80       	cmp    $0x80183c54,%eax
80103f04:	75 e4                	jne    80103eea <exit+0x8a>
      p->parent = initproc;
80103f06:	8b 0d 54 3c 18 80    	mov    0x80183c54,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0c:	ba 54 1d 18 80       	mov    $0x80181d54,%edx
80103f11:	eb 10                	jmp    80103f23 <exit+0xc3>
80103f13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f18:	83 c2 7c             	add    $0x7c,%edx
80103f1b:	81 fa 54 3c 18 80    	cmp    $0x80183c54,%edx
80103f21:	74 3b                	je     80103f5e <exit+0xfe>
    if(p->parent == curproc){
80103f23:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f26:	75 f0                	jne    80103f18 <exit+0xb8>
      if(p->state == ZOMBIE)
80103f28:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f2c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f2f:	75 e7                	jne    80103f18 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f31:	b8 54 1d 18 80       	mov    $0x80181d54,%eax
80103f36:	eb 12                	jmp    80103f4a <exit+0xea>
80103f38:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f3f:	00 
80103f40:	83 c0 7c             	add    $0x7c,%eax
80103f43:	3d 54 3c 18 80       	cmp    $0x80183c54,%eax
80103f48:	74 ce                	je     80103f18 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103f4a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f4e:	75 f0                	jne    80103f40 <exit+0xe0>
80103f50:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f53:	75 eb                	jne    80103f40 <exit+0xe0>
      p->state = RUNNABLE;
80103f55:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f5c:	eb e2                	jmp    80103f40 <exit+0xe0>
  curproc->state = ZOMBIE;
80103f5e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f65:	e8 36 fe ff ff       	call   80103da0 <sched>
  panic("zombie exit");
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 9e 76 10 80       	push   $0x8010769e
80103f72:	e8 09 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f77:	83 ec 0c             	sub    $0xc,%esp
80103f7a:	68 91 76 10 80       	push   $0x80107691
80103f7f:	e8 fc c3 ff ff       	call   80100380 <panic>
80103f84:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f8b:	00 
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f90 <wait>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
  pushcli();
80103f95:	e8 a6 05 00 00       	call   80104540 <pushcli>
  c = mycpu();
80103f9a:	e8 31 fa ff ff       	call   801039d0 <mycpu>
  p = c->proc;
80103f9f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fa5:	e8 e6 05 00 00       	call   80104590 <popcli>
  acquire(&ptable.lock);
80103faa:	83 ec 0c             	sub    $0xc,%esp
80103fad:	68 20 1d 18 80       	push   $0x80181d20
80103fb2:	e8 d9 06 00 00       	call   80104690 <acquire>
80103fb7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103fba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbc:	bb 54 1d 18 80       	mov    $0x80181d54,%ebx
80103fc1:	eb 10                	jmp    80103fd3 <wait+0x43>
80103fc3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fc8:	83 c3 7c             	add    $0x7c,%ebx
80103fcb:	81 fb 54 3c 18 80    	cmp    $0x80183c54,%ebx
80103fd1:	74 1b                	je     80103fee <wait+0x5e>
      if(p->parent != curproc)
80103fd3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fd6:	75 f0                	jne    80103fc8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fd8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fdc:	74 62                	je     80104040 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fde:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fe1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fe6:	81 fb 54 3c 18 80    	cmp    $0x80183c54,%ebx
80103fec:	75 e5                	jne    80103fd3 <wait+0x43>
    if(!havekids || curproc->killed){
80103fee:	85 c0                	test   %eax,%eax
80103ff0:	0f 84 a0 00 00 00    	je     80104096 <wait+0x106>
80103ff6:	8b 46 24             	mov    0x24(%esi),%eax
80103ff9:	85 c0                	test   %eax,%eax
80103ffb:	0f 85 95 00 00 00    	jne    80104096 <wait+0x106>
  pushcli();
80104001:	e8 3a 05 00 00       	call   80104540 <pushcli>
  c = mycpu();
80104006:	e8 c5 f9 ff ff       	call   801039d0 <mycpu>
  p = c->proc;
8010400b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104011:	e8 7a 05 00 00       	call   80104590 <popcli>
  if(p == 0)
80104016:	85 db                	test   %ebx,%ebx
80104018:	0f 84 8f 00 00 00    	je     801040ad <wait+0x11d>
  p->chan = chan;
8010401e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104021:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104028:	e8 73 fd ff ff       	call   80103da0 <sched>
  p->chan = 0;
8010402d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104034:	eb 84                	jmp    80103fba <wait+0x2a>
80104036:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010403d:	00 
8010403e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104040:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104043:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104046:	ff 73 08             	push   0x8(%ebx)
80104049:	e8 92 e4 ff ff       	call   801024e0 <kfree>
        p->kstack = 0;
8010404e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104055:	5a                   	pop    %edx
80104056:	ff 73 04             	push   0x4(%ebx)
80104059:	e8 b2 2f 00 00       	call   80107010 <freevm>
        p->pid = 0;
8010405e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104065:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010406c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104070:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104077:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010407e:	c7 04 24 20 1d 18 80 	movl   $0x80181d20,(%esp)
80104085:	e8 a6 05 00 00       	call   80104630 <release>
        return pid;
8010408a:	83 c4 10             	add    $0x10,%esp
}
8010408d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104090:	89 f0                	mov    %esi,%eax
80104092:	5b                   	pop    %ebx
80104093:	5e                   	pop    %esi
80104094:	5d                   	pop    %ebp
80104095:	c3                   	ret
      release(&ptable.lock);
80104096:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104099:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010409e:	68 20 1d 18 80       	push   $0x80181d20
801040a3:	e8 88 05 00 00       	call   80104630 <release>
      return -1;
801040a8:	83 c4 10             	add    $0x10,%esp
801040ab:	eb e0                	jmp    8010408d <wait+0xfd>
    panic("sleep");
801040ad:	83 ec 0c             	sub    $0xc,%esp
801040b0:	68 aa 76 10 80       	push   $0x801076aa
801040b5:	e8 c6 c2 ff ff       	call   80100380 <panic>
801040ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040c0 <yield>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040c7:	68 20 1d 18 80       	push   $0x80181d20
801040cc:	e8 bf 05 00 00       	call   80104690 <acquire>
  pushcli();
801040d1:	e8 6a 04 00 00       	call   80104540 <pushcli>
  c = mycpu();
801040d6:	e8 f5 f8 ff ff       	call   801039d0 <mycpu>
  p = c->proc;
801040db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040e1:	e8 aa 04 00 00       	call   80104590 <popcli>
  myproc()->state = RUNNABLE;
801040e6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040ed:	e8 ae fc ff ff       	call   80103da0 <sched>
  release(&ptable.lock);
801040f2:	c7 04 24 20 1d 18 80 	movl   $0x80181d20,(%esp)
801040f9:	e8 32 05 00 00       	call   80104630 <release>
}
801040fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104101:	83 c4 10             	add    $0x10,%esp
80104104:	c9                   	leave
80104105:	c3                   	ret
80104106:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010410d:	00 
8010410e:	66 90                	xchg   %ax,%ax

80104110 <sleep>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	57                   	push   %edi
80104114:	56                   	push   %esi
80104115:	53                   	push   %ebx
80104116:	83 ec 0c             	sub    $0xc,%esp
80104119:	8b 7d 08             	mov    0x8(%ebp),%edi
8010411c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010411f:	e8 1c 04 00 00       	call   80104540 <pushcli>
  c = mycpu();
80104124:	e8 a7 f8 ff ff       	call   801039d0 <mycpu>
  p = c->proc;
80104129:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010412f:	e8 5c 04 00 00       	call   80104590 <popcli>
  if(p == 0)
80104134:	85 db                	test   %ebx,%ebx
80104136:	0f 84 87 00 00 00    	je     801041c3 <sleep+0xb3>
  if(lk == 0)
8010413c:	85 f6                	test   %esi,%esi
8010413e:	74 76                	je     801041b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104140:	81 fe 20 1d 18 80    	cmp    $0x80181d20,%esi
80104146:	74 50                	je     80104198 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	68 20 1d 18 80       	push   $0x80181d20
80104150:	e8 3b 05 00 00       	call   80104690 <acquire>
    release(lk);
80104155:	89 34 24             	mov    %esi,(%esp)
80104158:	e8 d3 04 00 00       	call   80104630 <release>
  p->chan = chan;
8010415d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104160:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104167:	e8 34 fc ff ff       	call   80103da0 <sched>
  p->chan = 0;
8010416c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104173:	c7 04 24 20 1d 18 80 	movl   $0x80181d20,(%esp)
8010417a:	e8 b1 04 00 00       	call   80104630 <release>
    acquire(lk);
8010417f:	83 c4 10             	add    $0x10,%esp
80104182:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104185:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104188:	5b                   	pop    %ebx
80104189:	5e                   	pop    %esi
8010418a:	5f                   	pop    %edi
8010418b:	5d                   	pop    %ebp
    acquire(lk);
8010418c:	e9 ff 04 00 00       	jmp    80104690 <acquire>
80104191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104198:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010419b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041a2:	e8 f9 fb ff ff       	call   80103da0 <sched>
  p->chan = 0;
801041a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041b1:	5b                   	pop    %ebx
801041b2:	5e                   	pop    %esi
801041b3:	5f                   	pop    %edi
801041b4:	5d                   	pop    %ebp
801041b5:	c3                   	ret
    panic("sleep without lk");
801041b6:	83 ec 0c             	sub    $0xc,%esp
801041b9:	68 b0 76 10 80       	push   $0x801076b0
801041be:	e8 bd c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041c3:	83 ec 0c             	sub    $0xc,%esp
801041c6:	68 aa 76 10 80       	push   $0x801076aa
801041cb:	e8 b0 c1 ff ff       	call   80100380 <panic>

801041d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041d0:	55                   	push   %ebp
801041d1:	89 e5                	mov    %esp,%ebp
801041d3:	53                   	push   %ebx
801041d4:	83 ec 10             	sub    $0x10,%esp
801041d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041da:	68 20 1d 18 80       	push   $0x80181d20
801041df:	e8 ac 04 00 00       	call   80104690 <acquire>
801041e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041e7:	b8 54 1d 18 80       	mov    $0x80181d54,%eax
801041ec:	eb 0c                	jmp    801041fa <wakeup+0x2a>
801041ee:	66 90                	xchg   %ax,%ax
801041f0:	83 c0 7c             	add    $0x7c,%eax
801041f3:	3d 54 3c 18 80       	cmp    $0x80183c54,%eax
801041f8:	74 1c                	je     80104216 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801041fa:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041fe:	75 f0                	jne    801041f0 <wakeup+0x20>
80104200:	3b 58 20             	cmp    0x20(%eax),%ebx
80104203:	75 eb                	jne    801041f0 <wakeup+0x20>
      p->state = RUNNABLE;
80104205:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010420c:	83 c0 7c             	add    $0x7c,%eax
8010420f:	3d 54 3c 18 80       	cmp    $0x80183c54,%eax
80104214:	75 e4                	jne    801041fa <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104216:	c7 45 08 20 1d 18 80 	movl   $0x80181d20,0x8(%ebp)
}
8010421d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104220:	c9                   	leave
  release(&ptable.lock);
80104221:	e9 0a 04 00 00       	jmp    80104630 <release>
80104226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010422d:	00 
8010422e:	66 90                	xchg   %ax,%ax

80104230 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 10             	sub    $0x10,%esp
80104237:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010423a:	68 20 1d 18 80       	push   $0x80181d20
8010423f:	e8 4c 04 00 00       	call   80104690 <acquire>
80104244:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104247:	b8 54 1d 18 80       	mov    $0x80181d54,%eax
8010424c:	eb 0c                	jmp    8010425a <kill+0x2a>
8010424e:	66 90                	xchg   %ax,%ax
80104250:	83 c0 7c             	add    $0x7c,%eax
80104253:	3d 54 3c 18 80       	cmp    $0x80183c54,%eax
80104258:	74 36                	je     80104290 <kill+0x60>
    if(p->pid == pid){
8010425a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010425d:	75 f1                	jne    80104250 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010425f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104263:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010426a:	75 07                	jne    80104273 <kill+0x43>
        p->state = RUNNABLE;
8010426c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104273:	83 ec 0c             	sub    $0xc,%esp
80104276:	68 20 1d 18 80       	push   $0x80181d20
8010427b:	e8 b0 03 00 00       	call   80104630 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104283:	83 c4 10             	add    $0x10,%esp
80104286:	31 c0                	xor    %eax,%eax
}
80104288:	c9                   	leave
80104289:	c3                   	ret
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104290:	83 ec 0c             	sub    $0xc,%esp
80104293:	68 20 1d 18 80       	push   $0x80181d20
80104298:	e8 93 03 00 00       	call   80104630 <release>
}
8010429d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801042a0:	83 c4 10             	add    $0x10,%esp
801042a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042a8:	c9                   	leave
801042a9:	c3                   	ret
801042aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042b0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	57                   	push   %edi
801042b4:	56                   	push   %esi
801042b5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042b8:	53                   	push   %ebx
801042b9:	bb c0 1d 18 80       	mov    $0x80181dc0,%ebx
801042be:	83 ec 3c             	sub    $0x3c,%esp
801042c1:	eb 24                	jmp    801042e7 <procdump+0x37>
801042c3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042c8:	83 ec 0c             	sub    $0xc,%esp
801042cb:	68 7d 78 10 80       	push   $0x8010787d
801042d0:	e8 db c3 ff ff       	call   801006b0 <cprintf>
801042d5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042d8:	83 c3 7c             	add    $0x7c,%ebx
801042db:	81 fb c0 3c 18 80    	cmp    $0x80183cc0,%ebx
801042e1:	0f 84 81 00 00 00    	je     80104368 <procdump+0xb8>
    if(p->state == UNUSED)
801042e7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042ea:	85 c0                	test   %eax,%eax
801042ec:	74 ea                	je     801042d8 <procdump+0x28>
      state = "???";
801042ee:	ba c1 76 10 80       	mov    $0x801076c1,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042f3:	83 f8 05             	cmp    $0x5,%eax
801042f6:	77 11                	ja     80104309 <procdump+0x59>
801042f8:	8b 14 85 a0 7c 10 80 	mov    -0x7fef8360(,%eax,4),%edx
      state = "???";
801042ff:	b8 c1 76 10 80       	mov    $0x801076c1,%eax
80104304:	85 d2                	test   %edx,%edx
80104306:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104309:	53                   	push   %ebx
8010430a:	52                   	push   %edx
8010430b:	ff 73 a4             	push   -0x5c(%ebx)
8010430e:	68 c5 76 10 80       	push   $0x801076c5
80104313:	e8 98 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104318:	83 c4 10             	add    $0x10,%esp
8010431b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010431f:	75 a7                	jne    801042c8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104321:	83 ec 08             	sub    $0x8,%esp
80104324:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104327:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010432a:	50                   	push   %eax
8010432b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010432e:	8b 40 0c             	mov    0xc(%eax),%eax
80104331:	83 c0 08             	add    $0x8,%eax
80104334:	50                   	push   %eax
80104335:	e8 86 01 00 00       	call   801044c0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010433a:	83 c4 10             	add    $0x10,%esp
8010433d:	8d 76 00             	lea    0x0(%esi),%esi
80104340:	8b 17                	mov    (%edi),%edx
80104342:	85 d2                	test   %edx,%edx
80104344:	74 82                	je     801042c8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104346:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104349:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010434c:	52                   	push   %edx
8010434d:	68 01 74 10 80       	push   $0x80107401
80104352:	e8 59 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104357:	83 c4 10             	add    $0x10,%esp
8010435a:	39 f7                	cmp    %esi,%edi
8010435c:	75 e2                	jne    80104340 <procdump+0x90>
8010435e:	e9 65 ff ff ff       	jmp    801042c8 <procdump+0x18>
80104363:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104368:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010436b:	5b                   	pop    %ebx
8010436c:	5e                   	pop    %esi
8010436d:	5f                   	pop    %edi
8010436e:	5d                   	pop    %ebp
8010436f:	c3                   	ret

80104370 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	53                   	push   %ebx
80104374:	83 ec 0c             	sub    $0xc,%esp
80104377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010437a:	68 f8 76 10 80       	push   $0x801076f8
8010437f:	8d 43 04             	lea    0x4(%ebx),%eax
80104382:	50                   	push   %eax
80104383:	e8 18 01 00 00       	call   801044a0 <initlock>
  lk->name = name;
80104388:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010438b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104391:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104394:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010439b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010439e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a1:	c9                   	leave
801043a2:	c3                   	ret
801043a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043aa:	00 
801043ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801043b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	56                   	push   %esi
801043b4:	53                   	push   %ebx
801043b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043b8:	8d 73 04             	lea    0x4(%ebx),%esi
801043bb:	83 ec 0c             	sub    $0xc,%esp
801043be:	56                   	push   %esi
801043bf:	e8 cc 02 00 00       	call   80104690 <acquire>
  while (lk->locked) {
801043c4:	8b 13                	mov    (%ebx),%edx
801043c6:	83 c4 10             	add    $0x10,%esp
801043c9:	85 d2                	test   %edx,%edx
801043cb:	74 16                	je     801043e3 <acquiresleep+0x33>
801043cd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801043d0:	83 ec 08             	sub    $0x8,%esp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
801043d5:	e8 36 fd ff ff       	call   80104110 <sleep>
  while (lk->locked) {
801043da:	8b 03                	mov    (%ebx),%eax
801043dc:	83 c4 10             	add    $0x10,%esp
801043df:	85 c0                	test   %eax,%eax
801043e1:	75 ed                	jne    801043d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801043e3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043e9:	e8 62 f6 ff ff       	call   80103a50 <myproc>
801043ee:	8b 40 10             	mov    0x10(%eax),%eax
801043f1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043f4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043fa:	5b                   	pop    %ebx
801043fb:	5e                   	pop    %esi
801043fc:	5d                   	pop    %ebp
  release(&lk->lk);
801043fd:	e9 2e 02 00 00       	jmp    80104630 <release>
80104402:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104409:	00 
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104410 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
80104415:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104418:	8d 73 04             	lea    0x4(%ebx),%esi
8010441b:	83 ec 0c             	sub    $0xc,%esp
8010441e:	56                   	push   %esi
8010441f:	e8 6c 02 00 00       	call   80104690 <acquire>
  lk->locked = 0;
80104424:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010442a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104431:	89 1c 24             	mov    %ebx,(%esp)
80104434:	e8 97 fd ff ff       	call   801041d0 <wakeup>
  release(&lk->lk);
80104439:	83 c4 10             	add    $0x10,%esp
8010443c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010443f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104442:	5b                   	pop    %ebx
80104443:	5e                   	pop    %esi
80104444:	5d                   	pop    %ebp
  release(&lk->lk);
80104445:	e9 e6 01 00 00       	jmp    80104630 <release>
8010444a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104450 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	57                   	push   %edi
80104454:	31 ff                	xor    %edi,%edi
80104456:	56                   	push   %esi
80104457:	53                   	push   %ebx
80104458:	83 ec 18             	sub    $0x18,%esp
8010445b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010445e:	8d 73 04             	lea    0x4(%ebx),%esi
80104461:	56                   	push   %esi
80104462:	e8 29 02 00 00       	call   80104690 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104467:	8b 03                	mov    (%ebx),%eax
80104469:	83 c4 10             	add    $0x10,%esp
8010446c:	85 c0                	test   %eax,%eax
8010446e:	75 18                	jne    80104488 <holdingsleep+0x38>
  release(&lk->lk);
80104470:	83 ec 0c             	sub    $0xc,%esp
80104473:	56                   	push   %esi
80104474:	e8 b7 01 00 00       	call   80104630 <release>
  return r;
}
80104479:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010447c:	89 f8                	mov    %edi,%eax
8010447e:	5b                   	pop    %ebx
8010447f:	5e                   	pop    %esi
80104480:	5f                   	pop    %edi
80104481:	5d                   	pop    %ebp
80104482:	c3                   	ret
80104483:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104488:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010448b:	e8 c0 f5 ff ff       	call   80103a50 <myproc>
80104490:	39 58 10             	cmp    %ebx,0x10(%eax)
80104493:	0f 94 c0             	sete   %al
80104496:	0f b6 c0             	movzbl %al,%eax
80104499:	89 c7                	mov    %eax,%edi
8010449b:	eb d3                	jmp    80104470 <holdingsleep+0x20>
8010449d:	66 90                	xchg   %ax,%ax
8010449f:	90                   	nop

801044a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801044a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801044a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801044af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret
801044bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801044c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	8b 45 08             	mov    0x8(%ebp),%eax
801044c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801044ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044cd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801044d2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801044d7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044dc:	76 10                	jbe    801044ee <getcallerpcs+0x2e>
801044de:	eb 28                	jmp    80104508 <getcallerpcs+0x48>
801044e0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801044e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044ec:	77 1a                	ja     80104508 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044ee:	8b 5a 04             	mov    0x4(%edx),%ebx
801044f1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801044f4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801044f7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801044f9:	83 f8 0a             	cmp    $0xa,%eax
801044fc:	75 e2                	jne    801044e0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104501:	c9                   	leave
80104502:	c3                   	ret
80104503:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104508:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010450b:	83 c1 28             	add    $0x28,%ecx
8010450e:	89 ca                	mov    %ecx,%edx
80104510:	29 c2                	sub    %eax,%edx
80104512:	83 e2 04             	and    $0x4,%edx
80104515:	74 11                	je     80104528 <getcallerpcs+0x68>
    pcs[i] = 0;
80104517:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010451d:	83 c0 04             	add    $0x4,%eax
80104520:	39 c1                	cmp    %eax,%ecx
80104522:	74 da                	je     801044fe <getcallerpcs+0x3e>
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104528:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010452e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104531:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104538:	39 c1                	cmp    %eax,%ecx
8010453a:	75 ec                	jne    80104528 <getcallerpcs+0x68>
8010453c:	eb c0                	jmp    801044fe <getcallerpcs+0x3e>
8010453e:	66 90                	xchg   %ax,%ax

80104540 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 04             	sub    $0x4,%esp
80104547:	9c                   	pushf
80104548:	5b                   	pop    %ebx
  asm volatile("cli");
80104549:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010454a:	e8 81 f4 ff ff       	call   801039d0 <mycpu>
8010454f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104555:	85 c0                	test   %eax,%eax
80104557:	74 17                	je     80104570 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104559:	e8 72 f4 ff ff       	call   801039d0 <mycpu>
8010455e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104568:	c9                   	leave
80104569:	c3                   	ret
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104570:	e8 5b f4 ff ff       	call   801039d0 <mycpu>
80104575:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010457b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104581:	eb d6                	jmp    80104559 <pushcli+0x19>
80104583:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010458a:	00 
8010458b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104590 <popcli>:

void
popcli(void)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104596:	9c                   	pushf
80104597:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104598:	f6 c4 02             	test   $0x2,%ah
8010459b:	75 35                	jne    801045d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010459d:	e8 2e f4 ff ff       	call   801039d0 <mycpu>
801045a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801045a9:	78 34                	js     801045df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045ab:	e8 20 f4 ff ff       	call   801039d0 <mycpu>
801045b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045b6:	85 d2                	test   %edx,%edx
801045b8:	74 06                	je     801045c0 <popcli+0x30>
    sti();
}
801045ba:	c9                   	leave
801045bb:	c3                   	ret
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045c0:	e8 0b f4 ff ff       	call   801039d0 <mycpu>
801045c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045cb:	85 c0                	test   %eax,%eax
801045cd:	74 eb                	je     801045ba <popcli+0x2a>
  asm volatile("sti");
801045cf:	fb                   	sti
}
801045d0:	c9                   	leave
801045d1:	c3                   	ret
    panic("popcli - interruptible");
801045d2:	83 ec 0c             	sub    $0xc,%esp
801045d5:	68 03 77 10 80       	push   $0x80107703
801045da:	e8 a1 bd ff ff       	call   80100380 <panic>
    panic("popcli");
801045df:	83 ec 0c             	sub    $0xc,%esp
801045e2:	68 1a 77 10 80       	push   $0x8010771a
801045e7:	e8 94 bd ff ff       	call   80100380 <panic>
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045f0 <holding>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 75 08             	mov    0x8(%ebp),%esi
801045f8:	31 db                	xor    %ebx,%ebx
  pushcli();
801045fa:	e8 41 ff ff ff       	call   80104540 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045ff:	8b 06                	mov    (%esi),%eax
80104601:	85 c0                	test   %eax,%eax
80104603:	75 0b                	jne    80104610 <holding+0x20>
  popcli();
80104605:	e8 86 ff ff ff       	call   80104590 <popcli>
}
8010460a:	89 d8                	mov    %ebx,%eax
8010460c:	5b                   	pop    %ebx
8010460d:	5e                   	pop    %esi
8010460e:	5d                   	pop    %ebp
8010460f:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104610:	8b 5e 08             	mov    0x8(%esi),%ebx
80104613:	e8 b8 f3 ff ff       	call   801039d0 <mycpu>
80104618:	39 c3                	cmp    %eax,%ebx
8010461a:	0f 94 c3             	sete   %bl
  popcli();
8010461d:	e8 6e ff ff ff       	call   80104590 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104622:	0f b6 db             	movzbl %bl,%ebx
}
80104625:	89 d8                	mov    %ebx,%eax
80104627:	5b                   	pop    %ebx
80104628:	5e                   	pop    %esi
80104629:	5d                   	pop    %ebp
8010462a:	c3                   	ret
8010462b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104630 <release>:
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104638:	e8 03 ff ff ff       	call   80104540 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010463d:	8b 03                	mov    (%ebx),%eax
8010463f:	85 c0                	test   %eax,%eax
80104641:	75 15                	jne    80104658 <release+0x28>
  popcli();
80104643:	e8 48 ff ff ff       	call   80104590 <popcli>
    panic("release");
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 21 77 10 80       	push   $0x80107721
80104650:	e8 2b bd ff ff       	call   80100380 <panic>
80104655:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104658:	8b 73 08             	mov    0x8(%ebx),%esi
8010465b:	e8 70 f3 ff ff       	call   801039d0 <mycpu>
80104660:	39 c6                	cmp    %eax,%esi
80104662:	75 df                	jne    80104643 <release+0x13>
  popcli();
80104664:	e8 27 ff ff ff       	call   80104590 <popcli>
  lk->pcs[0] = 0;
80104669:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104670:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104677:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010467c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104682:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104685:	5b                   	pop    %ebx
80104686:	5e                   	pop    %esi
80104687:	5d                   	pop    %ebp
  popcli();
80104688:	e9 03 ff ff ff       	jmp    80104590 <popcli>
8010468d:	8d 76 00             	lea    0x0(%esi),%esi

80104690 <acquire>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104697:	e8 a4 fe ff ff       	call   80104540 <pushcli>
  if(holding(lk))
8010469c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010469f:	e8 9c fe ff ff       	call   80104540 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046a4:	8b 03                	mov    (%ebx),%eax
801046a6:	85 c0                	test   %eax,%eax
801046a8:	0f 85 b2 00 00 00    	jne    80104760 <acquire+0xd0>
  popcli();
801046ae:	e8 dd fe ff ff       	call   80104590 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801046b3:	b9 01 00 00 00       	mov    $0x1,%ecx
801046b8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046bf:	00 
  while(xchg(&lk->locked, 1) != 0)
801046c0:	8b 55 08             	mov    0x8(%ebp),%edx
801046c3:	89 c8                	mov    %ecx,%eax
801046c5:	f0 87 02             	lock xchg %eax,(%edx)
801046c8:	85 c0                	test   %eax,%eax
801046ca:	75 f4                	jne    801046c0 <acquire+0x30>
  __sync_synchronize();
801046cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046d4:	e8 f7 f2 ff ff       	call   801039d0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801046d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801046dc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801046de:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046e1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801046e7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801046ec:	77 32                	ja     80104720 <acquire+0x90>
  ebp = (uint*)v - 2;
801046ee:	89 e8                	mov    %ebp,%eax
801046f0:	eb 14                	jmp    80104706 <acquire+0x76>
801046f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046f8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104704:	77 1a                	ja     80104720 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
80104706:	8b 58 04             	mov    0x4(%eax),%ebx
80104709:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010470d:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104710:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104712:	83 fa 0a             	cmp    $0xa,%edx
80104715:	75 e1                	jne    801046f8 <acquire+0x68>
}
80104717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010471a:	c9                   	leave
8010471b:	c3                   	ret
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104720:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104724:	83 c1 34             	add    $0x34,%ecx
80104727:	89 ca                	mov    %ecx,%edx
80104729:	29 c2                	sub    %eax,%edx
8010472b:	83 e2 04             	and    $0x4,%edx
8010472e:	74 10                	je     80104740 <acquire+0xb0>
    pcs[i] = 0;
80104730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104736:	83 c0 04             	add    $0x4,%eax
80104739:	39 c1                	cmp    %eax,%ecx
8010473b:	74 da                	je     80104717 <acquire+0x87>
8010473d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104740:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104746:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104749:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104750:	39 c1                	cmp    %eax,%ecx
80104752:	75 ec                	jne    80104740 <acquire+0xb0>
80104754:	eb c1                	jmp    80104717 <acquire+0x87>
80104756:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010475d:	00 
8010475e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104760:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104763:	e8 68 f2 ff ff       	call   801039d0 <mycpu>
80104768:	39 c3                	cmp    %eax,%ebx
8010476a:	0f 85 3e ff ff ff    	jne    801046ae <acquire+0x1e>
  popcli();
80104770:	e8 1b fe ff ff       	call   80104590 <popcli>
    panic("acquire");
80104775:	83 ec 0c             	sub    $0xc,%esp
80104778:	68 29 77 10 80       	push   $0x80107729
8010477d:	e8 fe bb ff ff       	call   80100380 <panic>
80104782:	66 90                	xchg   %ax,%ax
80104784:	66 90                	xchg   %ax,%ax
80104786:	66 90                	xchg   %ax,%ax
80104788:	66 90                	xchg   %ax,%ax
8010478a:	66 90                	xchg   %ax,%ax
8010478c:	66 90                	xchg   %ax,%ax
8010478e:	66 90                	xchg   %ax,%ax

80104790 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	8b 55 08             	mov    0x8(%ebp),%edx
80104797:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010479a:	89 d0                	mov    %edx,%eax
8010479c:	09 c8                	or     %ecx,%eax
8010479e:	a8 03                	test   $0x3,%al
801047a0:	75 1e                	jne    801047c0 <memset+0x30>
    c &= 0xFF;
801047a2:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047a6:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
801047a9:	89 d7                	mov    %edx,%edi
801047ab:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801047b1:	fc                   	cld
801047b2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801047b7:	89 d0                	mov    %edx,%eax
801047b9:	c9                   	leave
801047ba:	c3                   	ret
801047bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801047c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801047c3:	89 d7                	mov    %edx,%edi
801047c5:	fc                   	cld
801047c6:	f3 aa                	rep stos %al,%es:(%edi)
801047c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801047cb:	89 d0                	mov    %edx,%eax
801047cd:	c9                   	leave
801047ce:	c3                   	ret
801047cf:	90                   	nop

801047d0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	56                   	push   %esi
801047d4:	8b 75 10             	mov    0x10(%ebp),%esi
801047d7:	8b 45 08             	mov    0x8(%ebp),%eax
801047da:	53                   	push   %ebx
801047db:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047de:	85 f6                	test   %esi,%esi
801047e0:	74 2e                	je     80104810 <memcmp+0x40>
801047e2:	01 c6                	add    %eax,%esi
801047e4:	eb 14                	jmp    801047fa <memcmp+0x2a>
801047e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047ed:	00 
801047ee:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801047f0:	83 c0 01             	add    $0x1,%eax
801047f3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801047f6:	39 f0                	cmp    %esi,%eax
801047f8:	74 16                	je     80104810 <memcmp+0x40>
    if(*s1 != *s2)
801047fa:	0f b6 08             	movzbl (%eax),%ecx
801047fd:	0f b6 1a             	movzbl (%edx),%ebx
80104800:	38 d9                	cmp    %bl,%cl
80104802:	74 ec                	je     801047f0 <memcmp+0x20>
      return *s1 - *s2;
80104804:	0f b6 c1             	movzbl %cl,%eax
80104807:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104809:	5b                   	pop    %ebx
8010480a:	5e                   	pop    %esi
8010480b:	5d                   	pop    %ebp
8010480c:	c3                   	ret
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
80104810:	5b                   	pop    %ebx
  return 0;
80104811:	31 c0                	xor    %eax,%eax
}
80104813:	5e                   	pop    %esi
80104814:	5d                   	pop    %ebp
80104815:	c3                   	ret
80104816:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010481d:	00 
8010481e:	66 90                	xchg   %ax,%ax

80104820 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	57                   	push   %edi
80104824:	8b 55 08             	mov    0x8(%ebp),%edx
80104827:	8b 45 10             	mov    0x10(%ebp),%eax
8010482a:	56                   	push   %esi
8010482b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010482e:	39 d6                	cmp    %edx,%esi
80104830:	73 26                	jae    80104858 <memmove+0x38>
80104832:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104835:	39 ca                	cmp    %ecx,%edx
80104837:	73 1f                	jae    80104858 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104839:	85 c0                	test   %eax,%eax
8010483b:	74 0f                	je     8010484c <memmove+0x2c>
8010483d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104840:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104844:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104847:	83 e8 01             	sub    $0x1,%eax
8010484a:	73 f4                	jae    80104840 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010484c:	5e                   	pop    %esi
8010484d:	89 d0                	mov    %edx,%eax
8010484f:	5f                   	pop    %edi
80104850:	5d                   	pop    %ebp
80104851:	c3                   	ret
80104852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104858:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010485b:	89 d7                	mov    %edx,%edi
8010485d:	85 c0                	test   %eax,%eax
8010485f:	74 eb                	je     8010484c <memmove+0x2c>
80104861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104868:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104869:	39 ce                	cmp    %ecx,%esi
8010486b:	75 fb                	jne    80104868 <memmove+0x48>
}
8010486d:	5e                   	pop    %esi
8010486e:	89 d0                	mov    %edx,%eax
80104870:	5f                   	pop    %edi
80104871:	5d                   	pop    %ebp
80104872:	c3                   	ret
80104873:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010487a:	00 
8010487b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104880 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104880:	eb 9e                	jmp    80104820 <memmove>
80104882:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104889:	00 
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	8b 55 10             	mov    0x10(%ebp),%edx
80104897:	8b 45 08             	mov    0x8(%ebp),%eax
8010489a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010489d:	85 d2                	test   %edx,%edx
8010489f:	75 16                	jne    801048b7 <strncmp+0x27>
801048a1:	eb 2d                	jmp    801048d0 <strncmp+0x40>
801048a3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801048a8:	3a 19                	cmp    (%ecx),%bl
801048aa:	75 12                	jne    801048be <strncmp+0x2e>
    n--, p++, q++;
801048ac:	83 c0 01             	add    $0x1,%eax
801048af:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048b2:	83 ea 01             	sub    $0x1,%edx
801048b5:	74 19                	je     801048d0 <strncmp+0x40>
801048b7:	0f b6 18             	movzbl (%eax),%ebx
801048ba:	84 db                	test   %bl,%bl
801048bc:	75 ea                	jne    801048a8 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048be:	0f b6 00             	movzbl (%eax),%eax
801048c1:	0f b6 11             	movzbl (%ecx),%edx
}
801048c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048c7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801048c8:	29 d0                	sub    %edx,%eax
}
801048ca:	c3                   	ret
801048cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801048d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801048d3:	31 c0                	xor    %eax,%eax
}
801048d5:	c9                   	leave
801048d6:	c3                   	ret
801048d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048de:	00 
801048df:	90                   	nop

801048e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	8b 75 08             	mov    0x8(%ebp),%esi
801048e8:	53                   	push   %ebx
801048e9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048ec:	89 f0                	mov    %esi,%eax
801048ee:	eb 15                	jmp    80104905 <strncpy+0x25>
801048f0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801048f4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801048f7:	83 c0 01             	add    $0x1,%eax
801048fa:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801048fe:	88 48 ff             	mov    %cl,-0x1(%eax)
80104901:	84 c9                	test   %cl,%cl
80104903:	74 13                	je     80104918 <strncpy+0x38>
80104905:	89 d3                	mov    %edx,%ebx
80104907:	83 ea 01             	sub    $0x1,%edx
8010490a:	85 db                	test   %ebx,%ebx
8010490c:	7f e2                	jg     801048f0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
8010490e:	5b                   	pop    %ebx
8010490f:	89 f0                	mov    %esi,%eax
80104911:	5e                   	pop    %esi
80104912:	5f                   	pop    %edi
80104913:	5d                   	pop    %ebp
80104914:	c3                   	ret
80104915:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104918:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010491b:	83 e9 01             	sub    $0x1,%ecx
8010491e:	85 d2                	test   %edx,%edx
80104920:	74 ec                	je     8010490e <strncpy+0x2e>
80104922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104928:	83 c0 01             	add    $0x1,%eax
8010492b:	89 ca                	mov    %ecx,%edx
8010492d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104931:	29 c2                	sub    %eax,%edx
80104933:	85 d2                	test   %edx,%edx
80104935:	7f f1                	jg     80104928 <strncpy+0x48>
}
80104937:	5b                   	pop    %ebx
80104938:	89 f0                	mov    %esi,%eax
8010493a:	5e                   	pop    %esi
8010493b:	5f                   	pop    %edi
8010493c:	5d                   	pop    %ebp
8010493d:	c3                   	ret
8010493e:	66 90                	xchg   %ax,%ax

80104940 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	56                   	push   %esi
80104944:	8b 55 10             	mov    0x10(%ebp),%edx
80104947:	8b 75 08             	mov    0x8(%ebp),%esi
8010494a:	53                   	push   %ebx
8010494b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010494e:	85 d2                	test   %edx,%edx
80104950:	7e 25                	jle    80104977 <safestrcpy+0x37>
80104952:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104956:	89 f2                	mov    %esi,%edx
80104958:	eb 16                	jmp    80104970 <safestrcpy+0x30>
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104960:	0f b6 08             	movzbl (%eax),%ecx
80104963:	83 c0 01             	add    $0x1,%eax
80104966:	83 c2 01             	add    $0x1,%edx
80104969:	88 4a ff             	mov    %cl,-0x1(%edx)
8010496c:	84 c9                	test   %cl,%cl
8010496e:	74 04                	je     80104974 <safestrcpy+0x34>
80104970:	39 d8                	cmp    %ebx,%eax
80104972:	75 ec                	jne    80104960 <safestrcpy+0x20>
    ;
  *s = 0;
80104974:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104977:	89 f0                	mov    %esi,%eax
80104979:	5b                   	pop    %ebx
8010497a:	5e                   	pop    %esi
8010497b:	5d                   	pop    %ebp
8010497c:	c3                   	ret
8010497d:	8d 76 00             	lea    0x0(%esi),%esi

80104980 <strlen>:

int
strlen(const char *s)
{
80104980:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104981:	31 c0                	xor    %eax,%eax
{
80104983:	89 e5                	mov    %esp,%ebp
80104985:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104988:	80 3a 00             	cmpb   $0x0,(%edx)
8010498b:	74 0c                	je     80104999 <strlen+0x19>
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
80104990:	83 c0 01             	add    $0x1,%eax
80104993:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104997:	75 f7                	jne    80104990 <strlen+0x10>
    ;
  return n;
}
80104999:	5d                   	pop    %ebp
8010499a:	c3                   	ret

8010499b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010499b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010499f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049a3:	55                   	push   %ebp
  pushl %ebx
801049a4:	53                   	push   %ebx
  pushl %esi
801049a5:	56                   	push   %esi
  pushl %edi
801049a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049a9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049ab:	5f                   	pop    %edi
  popl %esi
801049ac:	5e                   	pop    %esi
  popl %ebx
801049ad:	5b                   	pop    %ebx
  popl %ebp
801049ae:	5d                   	pop    %ebp
  ret
801049af:	c3                   	ret

801049b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	53                   	push   %ebx
801049b4:	83 ec 04             	sub    $0x4,%esp
801049b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049ba:	e8 91 f0 ff ff       	call   80103a50 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049bf:	8b 00                	mov    (%eax),%eax
801049c1:	39 c3                	cmp    %eax,%ebx
801049c3:	73 1b                	jae    801049e0 <fetchint+0x30>
801049c5:	8d 53 04             	lea    0x4(%ebx),%edx
801049c8:	39 d0                	cmp    %edx,%eax
801049ca:	72 14                	jb     801049e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049cf:	8b 13                	mov    (%ebx),%edx
801049d1:	89 10                	mov    %edx,(%eax)
  return 0;
801049d3:	31 c0                	xor    %eax,%eax
}
801049d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049d8:	c9                   	leave
801049d9:	c3                   	ret
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801049e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049e5:	eb ee                	jmp    801049d5 <fetchint+0x25>
801049e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049ee:	00 
801049ef:	90                   	nop

801049f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	53                   	push   %ebx
801049f4:	83 ec 04             	sub    $0x4,%esp
801049f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049fa:	e8 51 f0 ff ff       	call   80103a50 <myproc>

  if(addr >= curproc->sz)
801049ff:	3b 18                	cmp    (%eax),%ebx
80104a01:	73 2d                	jae    80104a30 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104a03:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a06:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104a08:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104a0a:	39 d3                	cmp    %edx,%ebx
80104a0c:	73 22                	jae    80104a30 <fetchstr+0x40>
80104a0e:	89 d8                	mov    %ebx,%eax
80104a10:	eb 0d                	jmp    80104a1f <fetchstr+0x2f>
80104a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a18:	83 c0 01             	add    $0x1,%eax
80104a1b:	39 d0                	cmp    %edx,%eax
80104a1d:	73 11                	jae    80104a30 <fetchstr+0x40>
    if(*s == 0)
80104a1f:	80 38 00             	cmpb   $0x0,(%eax)
80104a22:	75 f4                	jne    80104a18 <fetchstr+0x28>
      return s - *pp;
80104a24:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a29:	c9                   	leave
80104a2a:	c3                   	ret
80104a2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a38:	c9                   	leave
80104a39:	c3                   	ret
80104a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a40 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a45:	e8 06 f0 ff ff       	call   80103a50 <myproc>
80104a4a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a4d:	8b 40 18             	mov    0x18(%eax),%eax
80104a50:	8b 40 44             	mov    0x44(%eax),%eax
80104a53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a56:	e8 f5 ef ff ff       	call   80103a50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a5e:	8b 00                	mov    (%eax),%eax
80104a60:	39 c6                	cmp    %eax,%esi
80104a62:	73 1c                	jae    80104a80 <argint+0x40>
80104a64:	8d 53 08             	lea    0x8(%ebx),%edx
80104a67:	39 d0                	cmp    %edx,%eax
80104a69:	72 15                	jb     80104a80 <argint+0x40>
  *ip = *(int*)(addr);
80104a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a6e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a71:	89 10                	mov    %edx,(%eax)
  return 0;
80104a73:	31 c0                	xor    %eax,%eax
}
80104a75:	5b                   	pop    %ebx
80104a76:	5e                   	pop    %esi
80104a77:	5d                   	pop    %ebp
80104a78:	c3                   	ret
80104a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a85:	eb ee                	jmp    80104a75 <argint+0x35>
80104a87:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a8e:	00 
80104a8f:	90                   	nop

80104a90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	57                   	push   %edi
80104a94:	56                   	push   %esi
80104a95:	53                   	push   %ebx
80104a96:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104a99:	e8 b2 ef ff ff       	call   80103a50 <myproc>
80104a9e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aa0:	e8 ab ef ff ff       	call   80103a50 <myproc>
80104aa5:	8b 55 08             	mov    0x8(%ebp),%edx
80104aa8:	8b 40 18             	mov    0x18(%eax),%eax
80104aab:	8b 40 44             	mov    0x44(%eax),%eax
80104aae:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ab1:	e8 9a ef ff ff       	call   80103a50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ab6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ab9:	8b 00                	mov    (%eax),%eax
80104abb:	39 c7                	cmp    %eax,%edi
80104abd:	73 31                	jae    80104af0 <argptr+0x60>
80104abf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ac2:	39 c8                	cmp    %ecx,%eax
80104ac4:	72 2a                	jb     80104af0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ac6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ac9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104acc:	85 d2                	test   %edx,%edx
80104ace:	78 20                	js     80104af0 <argptr+0x60>
80104ad0:	8b 16                	mov    (%esi),%edx
80104ad2:	39 d0                	cmp    %edx,%eax
80104ad4:	73 1a                	jae    80104af0 <argptr+0x60>
80104ad6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ad9:	01 c3                	add    %eax,%ebx
80104adb:	39 da                	cmp    %ebx,%edx
80104add:	72 11                	jb     80104af0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104adf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ae2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ae4:	31 c0                	xor    %eax,%eax
}
80104ae6:	83 c4 0c             	add    $0xc,%esp
80104ae9:	5b                   	pop    %ebx
80104aea:	5e                   	pop    %esi
80104aeb:	5f                   	pop    %edi
80104aec:	5d                   	pop    %ebp
80104aed:	c3                   	ret
80104aee:	66 90                	xchg   %ax,%ax
    return -1;
80104af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af5:	eb ef                	jmp    80104ae6 <argptr+0x56>
80104af7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104afe:	00 
80104aff:	90                   	nop

80104b00 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b05:	e8 46 ef ff ff       	call   80103a50 <myproc>
80104b0a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b0d:	8b 40 18             	mov    0x18(%eax),%eax
80104b10:	8b 40 44             	mov    0x44(%eax),%eax
80104b13:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b16:	e8 35 ef ff ff       	call   80103a50 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b1b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b1e:	8b 00                	mov    (%eax),%eax
80104b20:	39 c6                	cmp    %eax,%esi
80104b22:	73 44                	jae    80104b68 <argstr+0x68>
80104b24:	8d 53 08             	lea    0x8(%ebx),%edx
80104b27:	39 d0                	cmp    %edx,%eax
80104b29:	72 3d                	jb     80104b68 <argstr+0x68>
  *ip = *(int*)(addr);
80104b2b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b2e:	e8 1d ef ff ff       	call   80103a50 <myproc>
  if(addr >= curproc->sz)
80104b33:	3b 18                	cmp    (%eax),%ebx
80104b35:	73 31                	jae    80104b68 <argstr+0x68>
  *pp = (char*)addr;
80104b37:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b3a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b3c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b3e:	39 d3                	cmp    %edx,%ebx
80104b40:	73 26                	jae    80104b68 <argstr+0x68>
80104b42:	89 d8                	mov    %ebx,%eax
80104b44:	eb 11                	jmp    80104b57 <argstr+0x57>
80104b46:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b4d:	00 
80104b4e:	66 90                	xchg   %ax,%ax
80104b50:	83 c0 01             	add    $0x1,%eax
80104b53:	39 d0                	cmp    %edx,%eax
80104b55:	73 11                	jae    80104b68 <argstr+0x68>
    if(*s == 0)
80104b57:	80 38 00             	cmpb   $0x0,(%eax)
80104b5a:	75 f4                	jne    80104b50 <argstr+0x50>
      return s - *pp;
80104b5c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b5e:	5b                   	pop    %ebx
80104b5f:	5e                   	pop    %esi
80104b60:	5d                   	pop    %ebp
80104b61:	c3                   	ret
80104b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b68:	5b                   	pop    %ebx
    return -1;
80104b69:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b6e:	5e                   	pop    %esi
80104b6f:	5d                   	pop    %ebp
80104b70:	c3                   	ret
80104b71:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b78:	00 
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b80 <syscall>:
[SYS_lseek]   sys_lseek,
};

void
syscall(void)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	53                   	push   %ebx
80104b84:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b87:	e8 c4 ee ff ff       	call   80103a50 <myproc>
80104b8c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b8e:	8b 40 18             	mov    0x18(%eax),%eax
80104b91:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b94:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b97:	83 fa 15             	cmp    $0x15,%edx
80104b9a:	77 24                	ja     80104bc0 <syscall+0x40>
80104b9c:	8b 14 85 c0 7c 10 80 	mov    -0x7fef8340(,%eax,4),%edx
80104ba3:	85 d2                	test   %edx,%edx
80104ba5:	74 19                	je     80104bc0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104ba7:	ff d2                	call   *%edx
80104ba9:	89 c2                	mov    %eax,%edx
80104bab:	8b 43 18             	mov    0x18(%ebx),%eax
80104bae:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb4:	c9                   	leave
80104bb5:	c3                   	ret
80104bb6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bbd:	00 
80104bbe:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104bc0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104bc1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bc4:	50                   	push   %eax
80104bc5:	ff 73 10             	push   0x10(%ebx)
80104bc8:	68 31 77 10 80       	push   $0x80107731
80104bcd:	e8 de ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104bd2:	8b 43 18             	mov    0x18(%ebx),%eax
80104bd5:	83 c4 10             	add    $0x10,%esp
80104bd8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104be2:	c9                   	leave
80104be3:	c3                   	ret
80104be4:	66 90                	xchg   %ax,%ax
80104be6:	66 90                	xchg   %ax,%ax
80104be8:	66 90                	xchg   %ax,%ax
80104bea:	66 90                	xchg   %ax,%ax
80104bec:	66 90                	xchg   %ax,%ax
80104bee:	66 90                	xchg   %ax,%ax

80104bf0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	57                   	push   %edi
80104bf4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104bf5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104bf8:	53                   	push   %ebx
80104bf9:	83 ec 34             	sub    $0x34,%esp
80104bfc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104bff:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104c02:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c05:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c08:	57                   	push   %edi
80104c09:	50                   	push   %eax
80104c0a:	e8 91 d4 ff ff       	call   801020a0 <nameiparent>
80104c0f:	83 c4 10             	add    $0x10,%esp
80104c12:	85 c0                	test   %eax,%eax
80104c14:	74 5e                	je     80104c74 <create+0x84>
    return 0;
  ilock(dp);
80104c16:	83 ec 0c             	sub    $0xc,%esp
80104c19:	89 c3                	mov    %eax,%ebx
80104c1b:	50                   	push   %eax
80104c1c:	e8 7f cb ff ff       	call   801017a0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c21:	83 c4 0c             	add    $0xc,%esp
80104c24:	6a 00                	push   $0x0
80104c26:	57                   	push   %edi
80104c27:	53                   	push   %ebx
80104c28:	e8 c3 d0 ff ff       	call   80101cf0 <dirlookup>
80104c2d:	83 c4 10             	add    $0x10,%esp
80104c30:	89 c6                	mov    %eax,%esi
80104c32:	85 c0                	test   %eax,%eax
80104c34:	74 4a                	je     80104c80 <create+0x90>
    iunlockput(dp);
80104c36:	83 ec 0c             	sub    $0xc,%esp
80104c39:	53                   	push   %ebx
80104c3a:	e8 f1 cd ff ff       	call   80101a30 <iunlockput>
    ilock(ip);
80104c3f:	89 34 24             	mov    %esi,(%esp)
80104c42:	e8 59 cb ff ff       	call   801017a0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c47:	83 c4 10             	add    $0x10,%esp
80104c4a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c4f:	75 17                	jne    80104c68 <create+0x78>
80104c51:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c56:	75 10                	jne    80104c68 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c5b:	89 f0                	mov    %esi,%eax
80104c5d:	5b                   	pop    %ebx
80104c5e:	5e                   	pop    %esi
80104c5f:	5f                   	pop    %edi
80104c60:	5d                   	pop    %ebp
80104c61:	c3                   	ret
80104c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104c68:	83 ec 0c             	sub    $0xc,%esp
80104c6b:	56                   	push   %esi
80104c6c:	e8 bf cd ff ff       	call   80101a30 <iunlockput>
    return 0;
80104c71:	83 c4 10             	add    $0x10,%esp
}
80104c74:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c77:	31 f6                	xor    %esi,%esi
}
80104c79:	5b                   	pop    %ebx
80104c7a:	89 f0                	mov    %esi,%eax
80104c7c:	5e                   	pop    %esi
80104c7d:	5f                   	pop    %edi
80104c7e:	5d                   	pop    %ebp
80104c7f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104c80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104c84:	83 ec 08             	sub    $0x8,%esp
80104c87:	50                   	push   %eax
80104c88:	ff 33                	push   (%ebx)
80104c8a:	e8 a1 c9 ff ff       	call   80101630 <ialloc>
80104c8f:	83 c4 10             	add    $0x10,%esp
80104c92:	89 c6                	mov    %eax,%esi
80104c94:	85 c0                	test   %eax,%eax
80104c96:	0f 84 bc 00 00 00    	je     80104d58 <create+0x168>
  ilock(ip);
80104c9c:	83 ec 0c             	sub    $0xc,%esp
80104c9f:	50                   	push   %eax
80104ca0:	e8 fb ca ff ff       	call   801017a0 <ilock>
  ip->major = major;
80104ca5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104ca9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104cad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104cb1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104cb5:	b8 01 00 00 00       	mov    $0x1,%eax
80104cba:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cbe:	89 34 24             	mov    %esi,(%esp)
80104cc1:	e8 2a ca ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cc6:	83 c4 10             	add    $0x10,%esp
80104cc9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104cce:	74 30                	je     80104d00 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104cd0:	83 ec 04             	sub    $0x4,%esp
80104cd3:	ff 76 04             	push   0x4(%esi)
80104cd6:	57                   	push   %edi
80104cd7:	53                   	push   %ebx
80104cd8:	e8 e3 d2 ff ff       	call   80101fc0 <dirlink>
80104cdd:	83 c4 10             	add    $0x10,%esp
80104ce0:	85 c0                	test   %eax,%eax
80104ce2:	78 67                	js     80104d4b <create+0x15b>
  iunlockput(dp);
80104ce4:	83 ec 0c             	sub    $0xc,%esp
80104ce7:	53                   	push   %ebx
80104ce8:	e8 43 cd ff ff       	call   80101a30 <iunlockput>
  return ip;
80104ced:	83 c4 10             	add    $0x10,%esp
}
80104cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cf3:	89 f0                	mov    %esi,%eax
80104cf5:	5b                   	pop    %ebx
80104cf6:	5e                   	pop    %esi
80104cf7:	5f                   	pop    %edi
80104cf8:	5d                   	pop    %ebp
80104cf9:	c3                   	ret
80104cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104d00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104d03:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104d08:	53                   	push   %ebx
80104d09:	e8 e2 c9 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d0e:	83 c4 0c             	add    $0xc,%esp
80104d11:	ff 76 04             	push   0x4(%esi)
80104d14:	68 69 77 10 80       	push   $0x80107769
80104d19:	56                   	push   %esi
80104d1a:	e8 a1 d2 ff ff       	call   80101fc0 <dirlink>
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	85 c0                	test   %eax,%eax
80104d24:	78 18                	js     80104d3e <create+0x14e>
80104d26:	83 ec 04             	sub    $0x4,%esp
80104d29:	ff 73 04             	push   0x4(%ebx)
80104d2c:	68 68 77 10 80       	push   $0x80107768
80104d31:	56                   	push   %esi
80104d32:	e8 89 d2 ff ff       	call   80101fc0 <dirlink>
80104d37:	83 c4 10             	add    $0x10,%esp
80104d3a:	85 c0                	test   %eax,%eax
80104d3c:	79 92                	jns    80104cd0 <create+0xe0>
      panic("create dots");
80104d3e:	83 ec 0c             	sub    $0xc,%esp
80104d41:	68 5c 77 10 80       	push   $0x8010775c
80104d46:	e8 35 b6 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104d4b:	83 ec 0c             	sub    $0xc,%esp
80104d4e:	68 6b 77 10 80       	push   $0x8010776b
80104d53:	e8 28 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104d58:	83 ec 0c             	sub    $0xc,%esp
80104d5b:	68 4d 77 10 80       	push   $0x8010774d
80104d60:	e8 1b b6 ff ff       	call   80100380 <panic>
80104d65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d6c:	00 
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

80104d70 <sys_dup>:
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d75:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104d78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d7b:	50                   	push   %eax
80104d7c:	6a 00                	push   $0x0
80104d7e:	e8 bd fc ff ff       	call   80104a40 <argint>
80104d83:	83 c4 10             	add    $0x10,%esp
80104d86:	85 c0                	test   %eax,%eax
80104d88:	78 36                	js     80104dc0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d8e:	77 30                	ja     80104dc0 <sys_dup+0x50>
80104d90:	e8 bb ec ff ff       	call   80103a50 <myproc>
80104d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d9c:	85 f6                	test   %esi,%esi
80104d9e:	74 20                	je     80104dc0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104da0:	e8 ab ec ff ff       	call   80103a50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104da5:	31 db                	xor    %ebx,%ebx
80104da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104dae:	00 
80104daf:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104db0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104db4:	85 d2                	test   %edx,%edx
80104db6:	74 18                	je     80104dd0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104db8:	83 c3 01             	add    $0x1,%ebx
80104dbb:	83 fb 10             	cmp    $0x10,%ebx
80104dbe:	75 f0                	jne    80104db0 <sys_dup+0x40>
}
80104dc0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104dc3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104dc8:	89 d8                	mov    %ebx,%eax
80104dca:	5b                   	pop    %ebx
80104dcb:	5e                   	pop    %esi
80104dcc:	5d                   	pop    %ebp
80104dcd:	c3                   	ret
80104dce:	66 90                	xchg   %ax,%ax
  filedup(f);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104dd3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104dd7:	56                   	push   %esi
80104dd8:	e8 e3 c0 ff ff       	call   80100ec0 <filedup>
  return fd;
80104ddd:	83 c4 10             	add    $0x10,%esp
}
80104de0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104de3:	89 d8                	mov    %ebx,%eax
80104de5:	5b                   	pop    %ebx
80104de6:	5e                   	pop    %esi
80104de7:	5d                   	pop    %ebp
80104de8:	c3                   	ret
80104de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104df0 <sys_read>:
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104df5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104df8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104dfb:	53                   	push   %ebx
80104dfc:	6a 00                	push   $0x0
80104dfe:	e8 3d fc ff ff       	call   80104a40 <argint>
80104e03:	83 c4 10             	add    $0x10,%esp
80104e06:	85 c0                	test   %eax,%eax
80104e08:	78 5e                	js     80104e68 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e0e:	77 58                	ja     80104e68 <sys_read+0x78>
80104e10:	e8 3b ec ff ff       	call   80103a50 <myproc>
80104e15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e18:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e1c:	85 f6                	test   %esi,%esi
80104e1e:	74 48                	je     80104e68 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e20:	83 ec 08             	sub    $0x8,%esp
80104e23:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e26:	50                   	push   %eax
80104e27:	6a 02                	push   $0x2
80104e29:	e8 12 fc ff ff       	call   80104a40 <argint>
80104e2e:	83 c4 10             	add    $0x10,%esp
80104e31:	85 c0                	test   %eax,%eax
80104e33:	78 33                	js     80104e68 <sys_read+0x78>
80104e35:	83 ec 04             	sub    $0x4,%esp
80104e38:	ff 75 f0             	push   -0x10(%ebp)
80104e3b:	53                   	push   %ebx
80104e3c:	6a 01                	push   $0x1
80104e3e:	e8 4d fc ff ff       	call   80104a90 <argptr>
80104e43:	83 c4 10             	add    $0x10,%esp
80104e46:	85 c0                	test   %eax,%eax
80104e48:	78 1e                	js     80104e68 <sys_read+0x78>
  return fileread(f, p, n);
80104e4a:	83 ec 04             	sub    $0x4,%esp
80104e4d:	ff 75 f0             	push   -0x10(%ebp)
80104e50:	ff 75 f4             	push   -0xc(%ebp)
80104e53:	56                   	push   %esi
80104e54:	e8 e7 c1 ff ff       	call   80101040 <fileread>
80104e59:	83 c4 10             	add    $0x10,%esp
}
80104e5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e5f:	5b                   	pop    %ebx
80104e60:	5e                   	pop    %esi
80104e61:	5d                   	pop    %ebp
80104e62:	c3                   	ret
80104e63:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e6d:	eb ed                	jmp    80104e5c <sys_read+0x6c>
80104e6f:	90                   	nop

80104e70 <sys_write>:
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e75:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e78:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e7b:	53                   	push   %ebx
80104e7c:	6a 00                	push   $0x0
80104e7e:	e8 bd fb ff ff       	call   80104a40 <argint>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	78 5e                	js     80104ee8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e8a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e8e:	77 58                	ja     80104ee8 <sys_write+0x78>
80104e90:	e8 bb eb ff ff       	call   80103a50 <myproc>
80104e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e98:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e9c:	85 f6                	test   %esi,%esi
80104e9e:	74 48                	je     80104ee8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ea0:	83 ec 08             	sub    $0x8,%esp
80104ea3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ea6:	50                   	push   %eax
80104ea7:	6a 02                	push   $0x2
80104ea9:	e8 92 fb ff ff       	call   80104a40 <argint>
80104eae:	83 c4 10             	add    $0x10,%esp
80104eb1:	85 c0                	test   %eax,%eax
80104eb3:	78 33                	js     80104ee8 <sys_write+0x78>
80104eb5:	83 ec 04             	sub    $0x4,%esp
80104eb8:	ff 75 f0             	push   -0x10(%ebp)
80104ebb:	53                   	push   %ebx
80104ebc:	6a 01                	push   $0x1
80104ebe:	e8 cd fb ff ff       	call   80104a90 <argptr>
80104ec3:	83 c4 10             	add    $0x10,%esp
80104ec6:	85 c0                	test   %eax,%eax
80104ec8:	78 1e                	js     80104ee8 <sys_write+0x78>
  return filewrite(f, p, n);
80104eca:	83 ec 04             	sub    $0x4,%esp
80104ecd:	ff 75 f0             	push   -0x10(%ebp)
80104ed0:	ff 75 f4             	push   -0xc(%ebp)
80104ed3:	56                   	push   %esi
80104ed4:	e8 f7 c1 ff ff       	call   801010d0 <filewrite>
80104ed9:	83 c4 10             	add    $0x10,%esp
}
80104edc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104edf:	5b                   	pop    %ebx
80104ee0:	5e                   	pop    %esi
80104ee1:	5d                   	pop    %ebp
80104ee2:	c3                   	ret
80104ee3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104ee8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eed:	eb ed                	jmp    80104edc <sys_write+0x6c>
80104eef:	90                   	nop

80104ef0 <sys_close>:
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ef8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104efb:	50                   	push   %eax
80104efc:	6a 00                	push   $0x0
80104efe:	e8 3d fb ff ff       	call   80104a40 <argint>
80104f03:	83 c4 10             	add    $0x10,%esp
80104f06:	85 c0                	test   %eax,%eax
80104f08:	78 3e                	js     80104f48 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f0a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f0e:	77 38                	ja     80104f48 <sys_close+0x58>
80104f10:	e8 3b eb ff ff       	call   80103a50 <myproc>
80104f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f18:	8d 5a 08             	lea    0x8(%edx),%ebx
80104f1b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104f1f:	85 f6                	test   %esi,%esi
80104f21:	74 25                	je     80104f48 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104f23:	e8 28 eb ff ff       	call   80103a50 <myproc>
  fileclose(f);
80104f28:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f2b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104f32:	00 
  fileclose(f);
80104f33:	56                   	push   %esi
80104f34:	e8 d7 bf ff ff       	call   80100f10 <fileclose>
  return 0;
80104f39:	83 c4 10             	add    $0x10,%esp
80104f3c:	31 c0                	xor    %eax,%eax
}
80104f3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f41:	5b                   	pop    %ebx
80104f42:	5e                   	pop    %esi
80104f43:	5d                   	pop    %ebp
80104f44:	c3                   	ret
80104f45:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4d:	eb ef                	jmp    80104f3e <sys_close+0x4e>
80104f4f:	90                   	nop

80104f50 <sys_fstat>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	56                   	push   %esi
80104f54:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f55:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f58:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f5b:	53                   	push   %ebx
80104f5c:	6a 00                	push   $0x0
80104f5e:	e8 dd fa ff ff       	call   80104a40 <argint>
80104f63:	83 c4 10             	add    $0x10,%esp
80104f66:	85 c0                	test   %eax,%eax
80104f68:	78 46                	js     80104fb0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f6e:	77 40                	ja     80104fb0 <sys_fstat+0x60>
80104f70:	e8 db ea ff ff       	call   80103a50 <myproc>
80104f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f78:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f7c:	85 f6                	test   %esi,%esi
80104f7e:	74 30                	je     80104fb0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f80:	83 ec 04             	sub    $0x4,%esp
80104f83:	6a 14                	push   $0x14
80104f85:	53                   	push   %ebx
80104f86:	6a 01                	push   $0x1
80104f88:	e8 03 fb ff ff       	call   80104a90 <argptr>
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	78 1c                	js     80104fb0 <sys_fstat+0x60>
  return filestat(f, st);
80104f94:	83 ec 08             	sub    $0x8,%esp
80104f97:	ff 75 f4             	push   -0xc(%ebp)
80104f9a:	56                   	push   %esi
80104f9b:	e8 50 c0 ff ff       	call   80100ff0 <filestat>
80104fa0:	83 c4 10             	add    $0x10,%esp
}
80104fa3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fa6:	5b                   	pop    %ebx
80104fa7:	5e                   	pop    %esi
80104fa8:	5d                   	pop    %ebp
80104fa9:	c3                   	ret
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb5:	eb ec                	jmp    80104fa3 <sys_fstat+0x53>
80104fb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fbe:	00 
80104fbf:	90                   	nop

80104fc0 <sys_link>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fc5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fc8:	53                   	push   %ebx
80104fc9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fcc:	50                   	push   %eax
80104fcd:	6a 00                	push   $0x0
80104fcf:	e8 2c fb ff ff       	call   80104b00 <argstr>
80104fd4:	83 c4 10             	add    $0x10,%esp
80104fd7:	85 c0                	test   %eax,%eax
80104fd9:	0f 88 fb 00 00 00    	js     801050da <sys_link+0x11a>
80104fdf:	83 ec 08             	sub    $0x8,%esp
80104fe2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fe5:	50                   	push   %eax
80104fe6:	6a 01                	push   $0x1
80104fe8:	e8 13 fb ff ff       	call   80104b00 <argstr>
80104fed:	83 c4 10             	add    $0x10,%esp
80104ff0:	85 c0                	test   %eax,%eax
80104ff2:	0f 88 e2 00 00 00    	js     801050da <sys_link+0x11a>
  begin_op();
80104ff8:	e8 33 de ff ff       	call   80102e30 <begin_op>
  if((ip = namei(old)) == 0){
80104ffd:	83 ec 0c             	sub    $0xc,%esp
80105000:	ff 75 d4             	push   -0x2c(%ebp)
80105003:	e8 78 d0 ff ff       	call   80102080 <namei>
80105008:	83 c4 10             	add    $0x10,%esp
8010500b:	89 c3                	mov    %eax,%ebx
8010500d:	85 c0                	test   %eax,%eax
8010500f:	0f 84 df 00 00 00    	je     801050f4 <sys_link+0x134>
  ilock(ip);
80105015:	83 ec 0c             	sub    $0xc,%esp
80105018:	50                   	push   %eax
80105019:	e8 82 c7 ff ff       	call   801017a0 <ilock>
  if(ip->type == T_DIR){
8010501e:	83 c4 10             	add    $0x10,%esp
80105021:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105026:	0f 84 b5 00 00 00    	je     801050e1 <sys_link+0x121>
  iupdate(ip);
8010502c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010502f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105034:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105037:	53                   	push   %ebx
80105038:	e8 b3 c6 ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
8010503d:	89 1c 24             	mov    %ebx,(%esp)
80105040:	e8 3b c8 ff ff       	call   80101880 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105045:	58                   	pop    %eax
80105046:	5a                   	pop    %edx
80105047:	57                   	push   %edi
80105048:	ff 75 d0             	push   -0x30(%ebp)
8010504b:	e8 50 d0 ff ff       	call   801020a0 <nameiparent>
80105050:	83 c4 10             	add    $0x10,%esp
80105053:	89 c6                	mov    %eax,%esi
80105055:	85 c0                	test   %eax,%eax
80105057:	74 5b                	je     801050b4 <sys_link+0xf4>
  ilock(dp);
80105059:	83 ec 0c             	sub    $0xc,%esp
8010505c:	50                   	push   %eax
8010505d:	e8 3e c7 ff ff       	call   801017a0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105062:	8b 03                	mov    (%ebx),%eax
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	39 06                	cmp    %eax,(%esi)
80105069:	75 3d                	jne    801050a8 <sys_link+0xe8>
8010506b:	83 ec 04             	sub    $0x4,%esp
8010506e:	ff 73 04             	push   0x4(%ebx)
80105071:	57                   	push   %edi
80105072:	56                   	push   %esi
80105073:	e8 48 cf ff ff       	call   80101fc0 <dirlink>
80105078:	83 c4 10             	add    $0x10,%esp
8010507b:	85 c0                	test   %eax,%eax
8010507d:	78 29                	js     801050a8 <sys_link+0xe8>
  iunlockput(dp);
8010507f:	83 ec 0c             	sub    $0xc,%esp
80105082:	56                   	push   %esi
80105083:	e8 a8 c9 ff ff       	call   80101a30 <iunlockput>
  iput(ip);
80105088:	89 1c 24             	mov    %ebx,(%esp)
8010508b:	e8 40 c8 ff ff       	call   801018d0 <iput>
  end_op();
80105090:	e8 0b de ff ff       	call   80102ea0 <end_op>
  return 0;
80105095:	83 c4 10             	add    $0x10,%esp
80105098:	31 c0                	xor    %eax,%eax
}
8010509a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010509d:	5b                   	pop    %ebx
8010509e:	5e                   	pop    %esi
8010509f:	5f                   	pop    %edi
801050a0:	5d                   	pop    %ebp
801050a1:	c3                   	ret
801050a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801050a8:	83 ec 0c             	sub    $0xc,%esp
801050ab:	56                   	push   %esi
801050ac:	e8 7f c9 ff ff       	call   80101a30 <iunlockput>
    goto bad;
801050b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050b4:	83 ec 0c             	sub    $0xc,%esp
801050b7:	53                   	push   %ebx
801050b8:	e8 e3 c6 ff ff       	call   801017a0 <ilock>
  ip->nlink--;
801050bd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050c2:	89 1c 24             	mov    %ebx,(%esp)
801050c5:	e8 26 c6 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801050ca:	89 1c 24             	mov    %ebx,(%esp)
801050cd:	e8 5e c9 ff ff       	call   80101a30 <iunlockput>
  end_op();
801050d2:	e8 c9 dd ff ff       	call   80102ea0 <end_op>
  return -1;
801050d7:	83 c4 10             	add    $0x10,%esp
    return -1;
801050da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050df:	eb b9                	jmp    8010509a <sys_link+0xda>
    iunlockput(ip);
801050e1:	83 ec 0c             	sub    $0xc,%esp
801050e4:	53                   	push   %ebx
801050e5:	e8 46 c9 ff ff       	call   80101a30 <iunlockput>
    end_op();
801050ea:	e8 b1 dd ff ff       	call   80102ea0 <end_op>
    return -1;
801050ef:	83 c4 10             	add    $0x10,%esp
801050f2:	eb e6                	jmp    801050da <sys_link+0x11a>
    end_op();
801050f4:	e8 a7 dd ff ff       	call   80102ea0 <end_op>
    return -1;
801050f9:	eb df                	jmp    801050da <sys_link+0x11a>
801050fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80105100 <sys_unlink>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105105:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105108:	53                   	push   %ebx
80105109:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010510c:	50                   	push   %eax
8010510d:	6a 00                	push   $0x0
8010510f:	e8 ec f9 ff ff       	call   80104b00 <argstr>
80105114:	83 c4 10             	add    $0x10,%esp
80105117:	85 c0                	test   %eax,%eax
80105119:	0f 88 54 01 00 00    	js     80105273 <sys_unlink+0x173>
  begin_op();
8010511f:	e8 0c dd ff ff       	call   80102e30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105124:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105127:	83 ec 08             	sub    $0x8,%esp
8010512a:	53                   	push   %ebx
8010512b:	ff 75 c0             	push   -0x40(%ebp)
8010512e:	e8 6d cf ff ff       	call   801020a0 <nameiparent>
80105133:	83 c4 10             	add    $0x10,%esp
80105136:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105139:	85 c0                	test   %eax,%eax
8010513b:	0f 84 58 01 00 00    	je     80105299 <sys_unlink+0x199>
  ilock(dp);
80105141:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105144:	83 ec 0c             	sub    $0xc,%esp
80105147:	57                   	push   %edi
80105148:	e8 53 c6 ff ff       	call   801017a0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010514d:	58                   	pop    %eax
8010514e:	5a                   	pop    %edx
8010514f:	68 69 77 10 80       	push   $0x80107769
80105154:	53                   	push   %ebx
80105155:	e8 76 cb ff ff       	call   80101cd0 <namecmp>
8010515a:	83 c4 10             	add    $0x10,%esp
8010515d:	85 c0                	test   %eax,%eax
8010515f:	0f 84 fb 00 00 00    	je     80105260 <sys_unlink+0x160>
80105165:	83 ec 08             	sub    $0x8,%esp
80105168:	68 68 77 10 80       	push   $0x80107768
8010516d:	53                   	push   %ebx
8010516e:	e8 5d cb ff ff       	call   80101cd0 <namecmp>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	0f 84 e2 00 00 00    	je     80105260 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010517e:	83 ec 04             	sub    $0x4,%esp
80105181:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105184:	50                   	push   %eax
80105185:	53                   	push   %ebx
80105186:	57                   	push   %edi
80105187:	e8 64 cb ff ff       	call   80101cf0 <dirlookup>
8010518c:	83 c4 10             	add    $0x10,%esp
8010518f:	89 c3                	mov    %eax,%ebx
80105191:	85 c0                	test   %eax,%eax
80105193:	0f 84 c7 00 00 00    	je     80105260 <sys_unlink+0x160>
  ilock(ip);
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	50                   	push   %eax
8010519d:	e8 fe c5 ff ff       	call   801017a0 <ilock>
  if(ip->nlink < 1)
801051a2:	83 c4 10             	add    $0x10,%esp
801051a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051aa:	0f 8e 0a 01 00 00    	jle    801052ba <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801051b8:	74 66                	je     80105220 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051ba:	83 ec 04             	sub    $0x4,%esp
801051bd:	6a 10                	push   $0x10
801051bf:	6a 00                	push   $0x0
801051c1:	57                   	push   %edi
801051c2:	e8 c9 f5 ff ff       	call   80104790 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051c7:	6a 10                	push   $0x10
801051c9:	ff 75 c4             	push   -0x3c(%ebp)
801051cc:	57                   	push   %edi
801051cd:	ff 75 b4             	push   -0x4c(%ebp)
801051d0:	e8 db c9 ff ff       	call   80101bb0 <writei>
801051d5:	83 c4 20             	add    $0x20,%esp
801051d8:	83 f8 10             	cmp    $0x10,%eax
801051db:	0f 85 cc 00 00 00    	jne    801052ad <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801051e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051e6:	0f 84 94 00 00 00    	je     80105280 <sys_unlink+0x180>
  iunlockput(dp);
801051ec:	83 ec 0c             	sub    $0xc,%esp
801051ef:	ff 75 b4             	push   -0x4c(%ebp)
801051f2:	e8 39 c8 ff ff       	call   80101a30 <iunlockput>
  ip->nlink--;
801051f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051fc:	89 1c 24             	mov    %ebx,(%esp)
801051ff:	e8 ec c4 ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105204:	89 1c 24             	mov    %ebx,(%esp)
80105207:	e8 24 c8 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010520c:	e8 8f dc ff ff       	call   80102ea0 <end_op>
  return 0;
80105211:	83 c4 10             	add    $0x10,%esp
80105214:	31 c0                	xor    %eax,%eax
}
80105216:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105219:	5b                   	pop    %ebx
8010521a:	5e                   	pop    %esi
8010521b:	5f                   	pop    %edi
8010521c:	5d                   	pop    %ebp
8010521d:	c3                   	ret
8010521e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105220:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105224:	76 94                	jbe    801051ba <sys_unlink+0xba>
80105226:	be 20 00 00 00       	mov    $0x20,%esi
8010522b:	eb 0b                	jmp    80105238 <sys_unlink+0x138>
8010522d:	8d 76 00             	lea    0x0(%esi),%esi
80105230:	83 c6 10             	add    $0x10,%esi
80105233:	3b 73 58             	cmp    0x58(%ebx),%esi
80105236:	73 82                	jae    801051ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105238:	6a 10                	push   $0x10
8010523a:	56                   	push   %esi
8010523b:	57                   	push   %edi
8010523c:	53                   	push   %ebx
8010523d:	e8 6e c8 ff ff       	call   80101ab0 <readi>
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	83 f8 10             	cmp    $0x10,%eax
80105248:	75 56                	jne    801052a0 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010524a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010524f:	74 df                	je     80105230 <sys_unlink+0x130>
    iunlockput(ip);
80105251:	83 ec 0c             	sub    $0xc,%esp
80105254:	53                   	push   %ebx
80105255:	e8 d6 c7 ff ff       	call   80101a30 <iunlockput>
    goto bad;
8010525a:	83 c4 10             	add    $0x10,%esp
8010525d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105260:	83 ec 0c             	sub    $0xc,%esp
80105263:	ff 75 b4             	push   -0x4c(%ebp)
80105266:	e8 c5 c7 ff ff       	call   80101a30 <iunlockput>
  end_op();
8010526b:	e8 30 dc ff ff       	call   80102ea0 <end_op>
  return -1;
80105270:	83 c4 10             	add    $0x10,%esp
    return -1;
80105273:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105278:	eb 9c                	jmp    80105216 <sys_unlink+0x116>
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105280:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105283:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105286:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010528b:	50                   	push   %eax
8010528c:	e8 5f c4 ff ff       	call   801016f0 <iupdate>
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	e9 53 ff ff ff       	jmp    801051ec <sys_unlink+0xec>
    end_op();
80105299:	e8 02 dc ff ff       	call   80102ea0 <end_op>
    return -1;
8010529e:	eb d3                	jmp    80105273 <sys_unlink+0x173>
      panic("isdirempty: readi");
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	68 8d 77 10 80       	push   $0x8010778d
801052a8:	e8 d3 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801052ad:	83 ec 0c             	sub    $0xc,%esp
801052b0:	68 9f 77 10 80       	push   $0x8010779f
801052b5:	e8 c6 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801052ba:	83 ec 0c             	sub    $0xc,%esp
801052bd:	68 7b 77 10 80       	push   $0x8010777b
801052c2:	e8 b9 b0 ff ff       	call   80100380 <panic>
801052c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052ce:	00 
801052cf:	90                   	nop

801052d0 <sys_open>:

int
sys_open(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	57                   	push   %edi
801052d4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052d8:	53                   	push   %ebx
801052d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052dc:	50                   	push   %eax
801052dd:	6a 00                	push   $0x0
801052df:	e8 1c f8 ff ff       	call   80104b00 <argstr>
801052e4:	83 c4 10             	add    $0x10,%esp
801052e7:	85 c0                	test   %eax,%eax
801052e9:	0f 88 8e 00 00 00    	js     8010537d <sys_open+0xad>
801052ef:	83 ec 08             	sub    $0x8,%esp
801052f2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052f5:	50                   	push   %eax
801052f6:	6a 01                	push   $0x1
801052f8:	e8 43 f7 ff ff       	call   80104a40 <argint>
801052fd:	83 c4 10             	add    $0x10,%esp
80105300:	85 c0                	test   %eax,%eax
80105302:	78 79                	js     8010537d <sys_open+0xad>
    return -1;

  begin_op();
80105304:	e8 27 db ff ff       	call   80102e30 <begin_op>

  if(omode & O_CREATE){
80105309:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010530d:	75 79                	jne    80105388 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010530f:	83 ec 0c             	sub    $0xc,%esp
80105312:	ff 75 e0             	push   -0x20(%ebp)
80105315:	e8 66 cd ff ff       	call   80102080 <namei>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	89 c6                	mov    %eax,%esi
8010531f:	85 c0                	test   %eax,%eax
80105321:	0f 84 7e 00 00 00    	je     801053a5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	50                   	push   %eax
8010532b:	e8 70 c4 ff ff       	call   801017a0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105338:	0f 84 ba 00 00 00    	je     801053f8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010533e:	e8 0d bb ff ff       	call   80100e50 <filealloc>
80105343:	89 c7                	mov    %eax,%edi
80105345:	85 c0                	test   %eax,%eax
80105347:	74 23                	je     8010536c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105349:	e8 02 e7 ff ff       	call   80103a50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010534e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105350:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105354:	85 d2                	test   %edx,%edx
80105356:	74 58                	je     801053b0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105358:	83 c3 01             	add    $0x1,%ebx
8010535b:	83 fb 10             	cmp    $0x10,%ebx
8010535e:	75 f0                	jne    80105350 <sys_open+0x80>
    if(f)
      fileclose(f);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	57                   	push   %edi
80105364:	e8 a7 bb ff ff       	call   80100f10 <fileclose>
80105369:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	56                   	push   %esi
80105370:	e8 bb c6 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105375:	e8 26 db ff ff       	call   80102ea0 <end_op>
    return -1;
8010537a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010537d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105382:	eb 65                	jmp    801053e9 <sys_open+0x119>
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	31 c9                	xor    %ecx,%ecx
8010538d:	ba 02 00 00 00       	mov    $0x2,%edx
80105392:	6a 00                	push   $0x0
80105394:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105397:	e8 54 f8 ff ff       	call   80104bf0 <create>
    if(ip == 0){
8010539c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010539f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053a1:	85 c0                	test   %eax,%eax
801053a3:	75 99                	jne    8010533e <sys_open+0x6e>
      end_op();
801053a5:	e8 f6 da ff ff       	call   80102ea0 <end_op>
      return -1;
801053aa:	eb d1                	jmp    8010537d <sys_open+0xad>
801053ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801053b0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053b3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053b7:	56                   	push   %esi
801053b8:	e8 c3 c4 ff ff       	call   80101880 <iunlock>
  end_op();
801053bd:	e8 de da ff ff       	call   80102ea0 <end_op>

  f->type = FD_INODE;
801053c2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053cb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801053ce:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801053d1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801053d3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053da:	f7 d0                	not    %eax
801053dc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053df:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801053e2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053e5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053ec:	89 d8                	mov    %ebx,%eax
801053ee:	5b                   	pop    %ebx
801053ef:	5e                   	pop    %esi
801053f0:	5f                   	pop    %edi
801053f1:	5d                   	pop    %ebp
801053f2:	c3                   	ret
801053f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801053f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053fb:	85 c9                	test   %ecx,%ecx
801053fd:	0f 84 3b ff ff ff    	je     8010533e <sys_open+0x6e>
80105403:	e9 64 ff ff ff       	jmp    8010536c <sys_open+0x9c>
80105408:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010540f:	00 

80105410 <sys_mkdir>:

int
sys_mkdir(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105416:	e8 15 da ff ff       	call   80102e30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010541b:	83 ec 08             	sub    $0x8,%esp
8010541e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105421:	50                   	push   %eax
80105422:	6a 00                	push   $0x0
80105424:	e8 d7 f6 ff ff       	call   80104b00 <argstr>
80105429:	83 c4 10             	add    $0x10,%esp
8010542c:	85 c0                	test   %eax,%eax
8010542e:	78 30                	js     80105460 <sys_mkdir+0x50>
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105436:	31 c9                	xor    %ecx,%ecx
80105438:	ba 01 00 00 00       	mov    $0x1,%edx
8010543d:	6a 00                	push   $0x0
8010543f:	e8 ac f7 ff ff       	call   80104bf0 <create>
80105444:	83 c4 10             	add    $0x10,%esp
80105447:	85 c0                	test   %eax,%eax
80105449:	74 15                	je     80105460 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010544b:	83 ec 0c             	sub    $0xc,%esp
8010544e:	50                   	push   %eax
8010544f:	e8 dc c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
80105454:	e8 47 da ff ff       	call   80102ea0 <end_op>
  return 0;
80105459:	83 c4 10             	add    $0x10,%esp
8010545c:	31 c0                	xor    %eax,%eax
}
8010545e:	c9                   	leave
8010545f:	c3                   	ret
    end_op();
80105460:	e8 3b da ff ff       	call   80102ea0 <end_op>
    return -1;
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010546a:	c9                   	leave
8010546b:	c3                   	ret
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_mknod>:

int
sys_mknod(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105476:	e8 b5 d9 ff ff       	call   80102e30 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010547b:	83 ec 08             	sub    $0x8,%esp
8010547e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105481:	50                   	push   %eax
80105482:	6a 00                	push   $0x0
80105484:	e8 77 f6 ff ff       	call   80104b00 <argstr>
80105489:	83 c4 10             	add    $0x10,%esp
8010548c:	85 c0                	test   %eax,%eax
8010548e:	78 60                	js     801054f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105496:	50                   	push   %eax
80105497:	6a 01                	push   $0x1
80105499:	e8 a2 f5 ff ff       	call   80104a40 <argint>
  if((argstr(0, &path)) < 0 ||
8010549e:	83 c4 10             	add    $0x10,%esp
801054a1:	85 c0                	test   %eax,%eax
801054a3:	78 4b                	js     801054f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801054a5:	83 ec 08             	sub    $0x8,%esp
801054a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ab:	50                   	push   %eax
801054ac:	6a 02                	push   $0x2
801054ae:	e8 8d f5 ff ff       	call   80104a40 <argint>
     argint(1, &major) < 0 ||
801054b3:	83 c4 10             	add    $0x10,%esp
801054b6:	85 c0                	test   %eax,%eax
801054b8:	78 36                	js     801054f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801054be:	83 ec 0c             	sub    $0xc,%esp
801054c1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054c5:	ba 03 00 00 00       	mov    $0x3,%edx
801054ca:	50                   	push   %eax
801054cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054ce:	e8 1d f7 ff ff       	call   80104bf0 <create>
     argint(2, &minor) < 0 ||
801054d3:	83 c4 10             	add    $0x10,%esp
801054d6:	85 c0                	test   %eax,%eax
801054d8:	74 16                	je     801054f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054da:	83 ec 0c             	sub    $0xc,%esp
801054dd:	50                   	push   %eax
801054de:	e8 4d c5 ff ff       	call   80101a30 <iunlockput>
  end_op();
801054e3:	e8 b8 d9 ff ff       	call   80102ea0 <end_op>
  return 0;
801054e8:	83 c4 10             	add    $0x10,%esp
801054eb:	31 c0                	xor    %eax,%eax
}
801054ed:	c9                   	leave
801054ee:	c3                   	ret
801054ef:	90                   	nop
    end_op();
801054f0:	e8 ab d9 ff ff       	call   80102ea0 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fa:	c9                   	leave
801054fb:	c3                   	ret
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_chdir>:

int
sys_chdir(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
80105505:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105508:	e8 43 e5 ff ff       	call   80103a50 <myproc>
8010550d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010550f:	e8 1c d9 ff ff       	call   80102e30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105514:	83 ec 08             	sub    $0x8,%esp
80105517:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010551a:	50                   	push   %eax
8010551b:	6a 00                	push   $0x0
8010551d:	e8 de f5 ff ff       	call   80104b00 <argstr>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	85 c0                	test   %eax,%eax
80105527:	78 77                	js     801055a0 <sys_chdir+0xa0>
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	ff 75 f4             	push   -0xc(%ebp)
8010552f:	e8 4c cb ff ff       	call   80102080 <namei>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	89 c3                	mov    %eax,%ebx
80105539:	85 c0                	test   %eax,%eax
8010553b:	74 63                	je     801055a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010553d:	83 ec 0c             	sub    $0xc,%esp
80105540:	50                   	push   %eax
80105541:	e8 5a c2 ff ff       	call   801017a0 <ilock>
  if(ip->type != T_DIR){
80105546:	83 c4 10             	add    $0x10,%esp
80105549:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010554e:	75 30                	jne    80105580 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	53                   	push   %ebx
80105554:	e8 27 c3 ff ff       	call   80101880 <iunlock>
  iput(curproc->cwd);
80105559:	58                   	pop    %eax
8010555a:	ff 76 68             	push   0x68(%esi)
8010555d:	e8 6e c3 ff ff       	call   801018d0 <iput>
  end_op();
80105562:	e8 39 d9 ff ff       	call   80102ea0 <end_op>
  curproc->cwd = ip;
80105567:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010556a:	83 c4 10             	add    $0x10,%esp
8010556d:	31 c0                	xor    %eax,%eax
}
8010556f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105572:	5b                   	pop    %ebx
80105573:	5e                   	pop    %esi
80105574:	5d                   	pop    %ebp
80105575:	c3                   	ret
80105576:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010557d:	00 
8010557e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105580:	83 ec 0c             	sub    $0xc,%esp
80105583:	53                   	push   %ebx
80105584:	e8 a7 c4 ff ff       	call   80101a30 <iunlockput>
    end_op();
80105589:	e8 12 d9 ff ff       	call   80102ea0 <end_op>
    return -1;
8010558e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105596:	eb d7                	jmp    8010556f <sys_chdir+0x6f>
80105598:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010559f:	00 
    end_op();
801055a0:	e8 fb d8 ff ff       	call   80102ea0 <end_op>
    return -1;
801055a5:	eb ea                	jmp    80105591 <sys_chdir+0x91>
801055a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055ae:	00 
801055af:	90                   	nop

801055b0 <sys_exec>:

int
sys_exec(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055b5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055bb:	53                   	push   %ebx
801055bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055c2:	50                   	push   %eax
801055c3:	6a 00                	push   $0x0
801055c5:	e8 36 f5 ff ff       	call   80104b00 <argstr>
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	85 c0                	test   %eax,%eax
801055cf:	0f 88 87 00 00 00    	js     8010565c <sys_exec+0xac>
801055d5:	83 ec 08             	sub    $0x8,%esp
801055d8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055de:	50                   	push   %eax
801055df:	6a 01                	push   $0x1
801055e1:	e8 5a f4 ff ff       	call   80104a40 <argint>
801055e6:	83 c4 10             	add    $0x10,%esp
801055e9:	85 c0                	test   %eax,%eax
801055eb:	78 6f                	js     8010565c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055ed:	83 ec 04             	sub    $0x4,%esp
801055f0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801055f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055f8:	68 80 00 00 00       	push   $0x80
801055fd:	6a 00                	push   $0x0
801055ff:	56                   	push   %esi
80105600:	e8 8b f1 ff ff       	call   80104790 <memset>
80105605:	83 c4 10             	add    $0x10,%esp
80105608:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010560f:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105610:	83 ec 08             	sub    $0x8,%esp
80105613:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105619:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105620:	50                   	push   %eax
80105621:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105627:	01 f8                	add    %edi,%eax
80105629:	50                   	push   %eax
8010562a:	e8 81 f3 ff ff       	call   801049b0 <fetchint>
8010562f:	83 c4 10             	add    $0x10,%esp
80105632:	85 c0                	test   %eax,%eax
80105634:	78 26                	js     8010565c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105636:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010563c:	85 c0                	test   %eax,%eax
8010563e:	74 30                	je     80105670 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105640:	83 ec 08             	sub    $0x8,%esp
80105643:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105646:	52                   	push   %edx
80105647:	50                   	push   %eax
80105648:	e8 a3 f3 ff ff       	call   801049f0 <fetchstr>
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	85 c0                	test   %eax,%eax
80105652:	78 08                	js     8010565c <sys_exec+0xac>
  for(i=0;; i++){
80105654:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105657:	83 fb 20             	cmp    $0x20,%ebx
8010565a:	75 b4                	jne    80105610 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010565c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010565f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105664:	5b                   	pop    %ebx
80105665:	5e                   	pop    %esi
80105666:	5f                   	pop    %edi
80105667:	5d                   	pop    %ebp
80105668:	c3                   	ret
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105670:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105677:	00 00 00 00 
  return exec(path, argv);
8010567b:	83 ec 08             	sub    $0x8,%esp
8010567e:	56                   	push   %esi
8010567f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105685:	e8 26 b4 ff ff       	call   80100ab0 <exec>
8010568a:	83 c4 10             	add    $0x10,%esp
}
8010568d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105690:	5b                   	pop    %ebx
80105691:	5e                   	pop    %esi
80105692:	5f                   	pop    %edi
80105693:	5d                   	pop    %ebp
80105694:	c3                   	ret
80105695:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010569c:	00 
8010569d:	8d 76 00             	lea    0x0(%esi),%esi

801056a0 <sys_pipe>:

int
sys_pipe(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801056a8:	53                   	push   %ebx
801056a9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056ac:	6a 08                	push   $0x8
801056ae:	50                   	push   %eax
801056af:	6a 00                	push   $0x0
801056b1:	e8 da f3 ff ff       	call   80104a90 <argptr>
801056b6:	83 c4 10             	add    $0x10,%esp
801056b9:	85 c0                	test   %eax,%eax
801056bb:	0f 88 8b 00 00 00    	js     8010574c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056c1:	83 ec 08             	sub    $0x8,%esp
801056c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056c7:	50                   	push   %eax
801056c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056cb:	50                   	push   %eax
801056cc:	e8 2f de ff ff       	call   80103500 <pipealloc>
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	78 74                	js     8010574c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056db:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056dd:	e8 6e e3 ff ff       	call   80103a50 <myproc>
    if(curproc->ofile[fd] == 0){
801056e2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056e6:	85 f6                	test   %esi,%esi
801056e8:	74 16                	je     80105700 <sys_pipe+0x60>
801056ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056f0:	83 c3 01             	add    $0x1,%ebx
801056f3:	83 fb 10             	cmp    $0x10,%ebx
801056f6:	74 3d                	je     80105735 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801056f8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056fc:	85 f6                	test   %esi,%esi
801056fe:	75 f0                	jne    801056f0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105700:	8d 73 08             	lea    0x8(%ebx),%esi
80105703:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105707:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010570a:	e8 41 e3 ff ff       	call   80103a50 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010570f:	31 d2                	xor    %edx,%edx
80105711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105718:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010571c:	85 c9                	test   %ecx,%ecx
8010571e:	74 38                	je     80105758 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105720:	83 c2 01             	add    $0x1,%edx
80105723:	83 fa 10             	cmp    $0x10,%edx
80105726:	75 f0                	jne    80105718 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105728:	e8 23 e3 ff ff       	call   80103a50 <myproc>
8010572d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105734:	00 
    fileclose(rf);
80105735:	83 ec 0c             	sub    $0xc,%esp
80105738:	ff 75 e0             	push   -0x20(%ebp)
8010573b:	e8 d0 b7 ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105740:	58                   	pop    %eax
80105741:	ff 75 e4             	push   -0x1c(%ebp)
80105744:	e8 c7 b7 ff ff       	call   80100f10 <fileclose>
    return -1;
80105749:	83 c4 10             	add    $0x10,%esp
    return -1;
8010574c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105751:	eb 16                	jmp    80105769 <sys_pipe+0xc9>
80105753:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105758:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010575c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010575f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105761:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105764:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105767:	31 c0                	xor    %eax,%eax
}
80105769:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010576c:	5b                   	pop    %ebx
8010576d:	5e                   	pop    %esi
8010576e:	5f                   	pop    %edi
8010576f:	5d                   	pop    %ebp
80105770:	c3                   	ret
80105771:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105778:	00 
80105779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105780 <sys_lseek>:

int sys_lseek(void) {
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	56                   	push   %esi
80105784:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105785:	8d 75 f4             	lea    -0xc(%ebp),%esi
int sys_lseek(void) {
80105788:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010578b:	56                   	push   %esi
8010578c:	6a 00                	push   $0x0
8010578e:	e8 ad f2 ff ff       	call   80104a40 <argint>
80105793:	83 c4 10             	add    $0x10,%esp
80105796:	85 c0                	test   %eax,%eax
80105798:	78 4e                	js     801057e8 <sys_lseek+0x68>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010579a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010579e:	77 48                	ja     801057e8 <sys_lseek+0x68>
801057a0:	e8 ab e2 ff ff       	call   80103a50 <myproc>
801057a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057a8:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
801057ac:	85 db                	test   %ebx,%ebx
801057ae:	74 38                	je     801057e8 <sys_lseek+0x68>
    struct file *f;
    int offset, whence, new_offset;

    // Get arguments: file descriptor, offset, and whence
    if (argfd(0, 0, &f) < 0 || argint(1, &offset) < 0 || argint(2, &whence) < 0)
801057b0:	83 ec 08             	sub    $0x8,%esp
801057b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b6:	50                   	push   %eax
801057b7:	6a 01                	push   $0x1
801057b9:	e8 82 f2 ff ff       	call   80104a40 <argint>
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	78 23                	js     801057e8 <sys_lseek+0x68>
801057c5:	83 ec 08             	sub    $0x8,%esp
801057c8:	56                   	push   %esi
801057c9:	6a 02                	push   $0x2
801057cb:	e8 70 f2 ff ff       	call   80104a40 <argint>
801057d0:	83 c4 10             	add    $0x10,%esp
801057d3:	85 c0                	test   %eax,%eax
801057d5:	78 11                	js     801057e8 <sys_lseek+0x68>
        return -1;

    switch (whence) {
801057d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057da:	83 f8 01             	cmp    $0x1,%eax
801057dd:	74 49                	je     80105828 <sys_lseek+0xa8>
801057df:	83 f8 02             	cmp    $0x2,%eax
801057e2:	74 14                	je     801057f8 <sys_lseek+0x78>
801057e4:	85 c0                	test   %eax,%eax
801057e6:	74 38                	je     80105820 <sys_lseek+0xa0>
    if (new_offset < 0 || new_offset > f->ip->size)
        return -1;

    f->off = new_offset;
    return new_offset;
}
801057e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
int sys_lseek(void) {
801057eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057f0:	5b                   	pop    %ebx
801057f1:	5e                   	pop    %esi
801057f2:	5d                   	pop    %ebp
801057f3:	c3                   	ret
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            new_offset = f->ip->size + offset;
801057f8:	8b 53 10             	mov    0x10(%ebx),%edx
801057fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057fe:	03 42 58             	add    0x58(%edx),%eax
    if (new_offset < 0 || new_offset > f->ip->size)
80105801:	85 c0                	test   %eax,%eax
80105803:	78 e3                	js     801057e8 <sys_lseek+0x68>
80105805:	8b 53 10             	mov    0x10(%ebx),%edx
80105808:	39 42 58             	cmp    %eax,0x58(%edx)
8010580b:	72 db                	jb     801057e8 <sys_lseek+0x68>
    f->off = new_offset;
8010580d:	89 43 14             	mov    %eax,0x14(%ebx)
}
80105810:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105813:	5b                   	pop    %ebx
80105814:	5e                   	pop    %esi
80105815:	5d                   	pop    %ebp
80105816:	c3                   	ret
80105817:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010581e:	00 
8010581f:	90                   	nop
            new_offset = offset;
80105820:	8b 45 f0             	mov    -0x10(%ebp),%eax
            break;
80105823:	eb dc                	jmp    80105801 <sys_lseek+0x81>
80105825:	8d 76 00             	lea    0x0(%esi),%esi
            new_offset = f->off + offset;
80105828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010582b:	03 43 14             	add    0x14(%ebx),%eax
            break;
8010582e:	eb d1                	jmp    80105801 <sys_lseek+0x81>

80105830 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105830:	e9 bb e3 ff ff       	jmp    80103bf0 <fork>
80105835:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010583c:	00 
8010583d:	8d 76 00             	lea    0x0(%esi),%esi

80105840 <sys_exit>:
}

int
sys_exit(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	83 ec 08             	sub    $0x8,%esp
  exit();
80105846:	e8 15 e6 ff ff       	call   80103e60 <exit>
  return 0;  // not reached
}
8010584b:	31 c0                	xor    %eax,%eax
8010584d:	c9                   	leave
8010584e:	c3                   	ret
8010584f:	90                   	nop

80105850 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105850:	e9 3b e7 ff ff       	jmp    80103f90 <wait>
80105855:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010585c:	00 
8010585d:	8d 76 00             	lea    0x0(%esi),%esi

80105860 <sys_kill>:
}

int
sys_kill(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105866:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105869:	50                   	push   %eax
8010586a:	6a 00                	push   $0x0
8010586c:	e8 cf f1 ff ff       	call   80104a40 <argint>
80105871:	83 c4 10             	add    $0x10,%esp
80105874:	85 c0                	test   %eax,%eax
80105876:	78 18                	js     80105890 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	ff 75 f4             	push   -0xc(%ebp)
8010587e:	e8 ad e9 ff ff       	call   80104230 <kill>
80105883:	83 c4 10             	add    $0x10,%esp
}
80105886:	c9                   	leave
80105887:	c3                   	ret
80105888:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010588f:	00 
80105890:	c9                   	leave
    return -1;
80105891:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105896:	c3                   	ret
80105897:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589e:	00 
8010589f:	90                   	nop

801058a0 <sys_getpid>:

int
sys_getpid(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058a6:	e8 a5 e1 ff ff       	call   80103a50 <myproc>
801058ab:	8b 40 10             	mov    0x10(%eax),%eax
}
801058ae:	c9                   	leave
801058af:	c3                   	ret

801058b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058b7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058ba:	50                   	push   %eax
801058bb:	6a 00                	push   $0x0
801058bd:	e8 7e f1 ff ff       	call   80104a40 <argint>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	85 c0                	test   %eax,%eax
801058c7:	78 27                	js     801058f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801058c9:	e8 82 e1 ff ff       	call   80103a50 <myproc>
  if(growproc(n) < 0)
801058ce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801058d1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801058d3:	ff 75 f4             	push   -0xc(%ebp)
801058d6:	e8 95 e2 ff ff       	call   80103b70 <growproc>
801058db:	83 c4 10             	add    $0x10,%esp
801058de:	85 c0                	test   %eax,%eax
801058e0:	78 0e                	js     801058f0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801058e2:	89 d8                	mov    %ebx,%eax
801058e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801058e7:	c9                   	leave
801058e8:	c3                   	ret
801058e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801058f0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801058f5:	eb eb                	jmp    801058e2 <sys_sbrk+0x32>
801058f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058fe:	00 
801058ff:	90                   	nop

80105900 <sys_sleep>:

int
sys_sleep(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105904:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105907:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010590a:	50                   	push   %eax
8010590b:	6a 00                	push   $0x0
8010590d:	e8 2e f1 ff ff       	call   80104a40 <argint>
80105912:	83 c4 10             	add    $0x10,%esp
80105915:	85 c0                	test   %eax,%eax
80105917:	78 64                	js     8010597d <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105919:	83 ec 0c             	sub    $0xc,%esp
8010591c:	68 80 3c 18 80       	push   $0x80183c80
80105921:	e8 6a ed ff ff       	call   80104690 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105926:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105929:	8b 1d 60 3c 18 80    	mov    0x80183c60,%ebx
  while(ticks - ticks0 < n){
8010592f:	83 c4 10             	add    $0x10,%esp
80105932:	85 d2                	test   %edx,%edx
80105934:	75 2b                	jne    80105961 <sys_sleep+0x61>
80105936:	eb 58                	jmp    80105990 <sys_sleep+0x90>
80105938:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010593f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105940:	83 ec 08             	sub    $0x8,%esp
80105943:	68 80 3c 18 80       	push   $0x80183c80
80105948:	68 60 3c 18 80       	push   $0x80183c60
8010594d:	e8 be e7 ff ff       	call   80104110 <sleep>
  while(ticks - ticks0 < n){
80105952:	a1 60 3c 18 80       	mov    0x80183c60,%eax
80105957:	83 c4 10             	add    $0x10,%esp
8010595a:	29 d8                	sub    %ebx,%eax
8010595c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010595f:	73 2f                	jae    80105990 <sys_sleep+0x90>
    if(myproc()->killed){
80105961:	e8 ea e0 ff ff       	call   80103a50 <myproc>
80105966:	8b 40 24             	mov    0x24(%eax),%eax
80105969:	85 c0                	test   %eax,%eax
8010596b:	74 d3                	je     80105940 <sys_sleep+0x40>
      release(&tickslock);
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	68 80 3c 18 80       	push   $0x80183c80
80105975:	e8 b6 ec ff ff       	call   80104630 <release>
      return -1;
8010597a:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
8010597d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105985:	c9                   	leave
80105986:	c3                   	ret
80105987:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010598e:	00 
8010598f:	90                   	nop
  release(&tickslock);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	68 80 3c 18 80       	push   $0x80183c80
80105998:	e8 93 ec ff ff       	call   80104630 <release>
}
8010599d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801059a0:	83 c4 10             	add    $0x10,%esp
801059a3:	31 c0                	xor    %eax,%eax
}
801059a5:	c9                   	leave
801059a6:	c3                   	ret
801059a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ae:	00 
801059af:	90                   	nop

801059b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
801059b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801059b7:	68 80 3c 18 80       	push   $0x80183c80
801059bc:	e8 cf ec ff ff       	call   80104690 <acquire>
  xticks = ticks;
801059c1:	8b 1d 60 3c 18 80    	mov    0x80183c60,%ebx
  release(&tickslock);
801059c7:	c7 04 24 80 3c 18 80 	movl   $0x80183c80,(%esp)
801059ce:	e8 5d ec ff ff       	call   80104630 <release>
  return xticks;
}
801059d3:	89 d8                	mov    %ebx,%eax
801059d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059d8:	c9                   	leave
801059d9:	c3                   	ret

801059da <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801059da:	1e                   	push   %ds
  pushl %es
801059db:	06                   	push   %es
  pushl %fs
801059dc:	0f a0                	push   %fs
  pushl %gs
801059de:	0f a8                	push   %gs
  pushal
801059e0:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801059e1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801059e5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801059e7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801059e9:	54                   	push   %esp
  call trap
801059ea:	e8 c1 00 00 00       	call   80105ab0 <trap>
  addl $4, %esp
801059ef:	83 c4 04             	add    $0x4,%esp

801059f2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801059f2:	61                   	popa
  popl %gs
801059f3:	0f a9                	pop    %gs
  popl %fs
801059f5:	0f a1                	pop    %fs
  popl %es
801059f7:	07                   	pop    %es
  popl %ds
801059f8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801059f9:	83 c4 08             	add    $0x8,%esp
  iret
801059fc:	cf                   	iret
801059fd:	66 90                	xchg   %ax,%ax
801059ff:	90                   	nop

80105a00 <tvinit>:
}


void
tvinit(void)
{
80105a00:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a01:	31 c0                	xor    %eax,%eax
{
80105a03:	89 e5                	mov    %esp,%ebp
80105a05:	83 ec 08             	sub    $0x8,%esp
80105a08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a0f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a10:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a17:	c7 04 c5 c2 3c 18 80 	movl   $0x8e000008,-0x7fe7c33e(,%eax,8)
80105a1e:	08 00 00 8e 
80105a22:	66 89 14 c5 c0 3c 18 	mov    %dx,-0x7fe7c340(,%eax,8)
80105a29:	80 
80105a2a:	c1 ea 10             	shr    $0x10,%edx
80105a2d:	66 89 14 c5 c6 3c 18 	mov    %dx,-0x7fe7c33a(,%eax,8)
80105a34:	80 
  for(i = 0; i < 256; i++)
80105a35:	83 c0 01             	add    $0x1,%eax
80105a38:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a3d:	75 d1                	jne    80105a10 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105a3f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a42:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105a47:	c7 05 c2 3e 18 80 08 	movl   $0xef000008,0x80183ec2
80105a4e:	00 00 ef 
  initlock(&tickslock, "time");
80105a51:	68 ae 77 10 80       	push   $0x801077ae
80105a56:	68 80 3c 18 80       	push   $0x80183c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a5b:	66 a3 c0 3e 18 80    	mov    %ax,0x80183ec0
80105a61:	c1 e8 10             	shr    $0x10,%eax
80105a64:	66 a3 c6 3e 18 80    	mov    %ax,0x80183ec6
  initlock(&tickslock, "time");
80105a6a:	e8 31 ea ff ff       	call   801044a0 <initlock>
}
80105a6f:	83 c4 10             	add    $0x10,%esp
80105a72:	c9                   	leave
80105a73:	c3                   	ret
80105a74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a7b:	00 
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <idtinit>:

void
idtinit(void)
{
80105a80:	55                   	push   %ebp
  pd[0] = size-1;
80105a81:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105a86:	89 e5                	mov    %esp,%ebp
80105a88:	83 ec 10             	sub    $0x10,%esp
80105a8b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105a8f:	b8 c0 3c 18 80       	mov    $0x80183cc0,%eax
80105a94:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105a98:	c1 e8 10             	shr    $0x10,%eax
80105a9b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105a9f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105aa2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105aa5:	c9                   	leave
80105aa6:	c3                   	ret
80105aa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aae:	00 
80105aaf:	90                   	nop

80105ab0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	57                   	push   %edi
80105ab4:	56                   	push   %esi
80105ab5:	53                   	push   %ebx
80105ab6:	83 ec 1c             	sub    $0x1c,%esp
80105ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105abc:	8b 43 30             	mov    0x30(%ebx),%eax
80105abf:	83 f8 40             	cmp    $0x40,%eax
80105ac2:	0f 84 68 01 00 00    	je     80105c30 <trap+0x180>
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }
  if (tf->trapno == T_PGFLT) {  // Page fault
80105ac8:	83 f8 0e             	cmp    $0xe,%eax
80105acb:	0f 84 ef 01 00 00    	je     80105cc0 <trap+0x210>
      
      return;
    }
  }

  switch(tf->trapno){
80105ad1:	83 e8 20             	sub    $0x20,%eax
80105ad4:	83 f8 1f             	cmp    $0x1f,%eax
80105ad7:	0f 87 83 00 00 00    	ja     80105b60 <trap+0xb0>
80105add:	ff 24 85 1c 7d 10 80 	jmp    *-0x7fef82e4(,%eax,4)
80105ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105ae8:	e8 43 df ff ff       	call   80103a30 <cpuid>
80105aed:	85 c0                	test   %eax,%eax
80105aef:	0f 84 8b 02 00 00    	je     80105d80 <trap+0x2d0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105af5:	e8 e6 ce ff ff       	call   801029e0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105afa:	e8 51 df ff ff       	call   80103a50 <myproc>
80105aff:	85 c0                	test   %eax,%eax
80105b01:	74 1a                	je     80105b1d <trap+0x6d>
80105b03:	e8 48 df ff ff       	call   80103a50 <myproc>
80105b08:	8b 50 24             	mov    0x24(%eax),%edx
80105b0b:	85 d2                	test   %edx,%edx
80105b0d:	74 0e                	je     80105b1d <trap+0x6d>
80105b0f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b13:	f7 d0                	not    %eax
80105b15:	a8 03                	test   $0x3,%al
80105b17:	0f 84 e3 01 00 00    	je     80105d00 <trap+0x250>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b1d:	e8 2e df ff ff       	call   80103a50 <myproc>
80105b22:	85 c0                	test   %eax,%eax
80105b24:	74 0f                	je     80105b35 <trap+0x85>
80105b26:	e8 25 df ff ff       	call   80103a50 <myproc>
80105b2b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b2f:	0f 84 ab 00 00 00    	je     80105be0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b35:	e8 16 df ff ff       	call   80103a50 <myproc>
80105b3a:	85 c0                	test   %eax,%eax
80105b3c:	74 1a                	je     80105b58 <trap+0xa8>
80105b3e:	e8 0d df ff ff       	call   80103a50 <myproc>
80105b43:	8b 40 24             	mov    0x24(%eax),%eax
80105b46:	85 c0                	test   %eax,%eax
80105b48:	74 0e                	je     80105b58 <trap+0xa8>
80105b4a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b4e:	f7 d0                	not    %eax
80105b50:	a8 03                	test   $0x3,%al
80105b52:	0f 84 05 01 00 00    	je     80105c5d <trap+0x1ad>
    exit();
}
80105b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b5b:	5b                   	pop    %ebx
80105b5c:	5e                   	pop    %esi
80105b5d:	5f                   	pop    %edi
80105b5e:	5d                   	pop    %ebp
80105b5f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b60:	e8 eb de ff ff       	call   80103a50 <myproc>
80105b65:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b68:	85 c0                	test   %eax,%eax
80105b6a:	0f 84 52 02 00 00    	je     80105dc2 <trap+0x312>
80105b70:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b74:	0f 84 48 02 00 00    	je     80105dc2 <trap+0x312>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b7a:	0f 20 d1             	mov    %cr2,%ecx
80105b7d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b80:	e8 ab de ff ff       	call   80103a30 <cpuid>
80105b85:	8b 73 30             	mov    0x30(%ebx),%esi
80105b88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105b8b:	8b 43 34             	mov    0x34(%ebx),%eax
80105b8e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105b91:	e8 ba de ff ff       	call   80103a50 <myproc>
80105b96:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105b99:	e8 b2 de ff ff       	call   80103a50 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b9e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ba1:	51                   	push   %ecx
80105ba2:	57                   	push   %edi
80105ba3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ba6:	52                   	push   %edx
80105ba7:	ff 75 e4             	push   -0x1c(%ebp)
80105baa:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105bab:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105bae:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bb1:	56                   	push   %esi
80105bb2:	ff 70 10             	push   0x10(%eax)
80105bb5:	68 0c 7a 10 80       	push   $0x80107a0c
80105bba:	e8 f1 aa ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105bbf:	83 c4 20             	add    $0x20,%esp
80105bc2:	e8 89 de ff ff       	call   80103a50 <myproc>
80105bc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bce:	e8 7d de ff ff       	call   80103a50 <myproc>
80105bd3:	85 c0                	test   %eax,%eax
80105bd5:	0f 85 28 ff ff ff    	jne    80105b03 <trap+0x53>
80105bdb:	e9 3d ff ff ff       	jmp    80105b1d <trap+0x6d>
  if(myproc() && myproc()->state == RUNNING &&
80105be0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105be4:	0f 85 4b ff ff ff    	jne    80105b35 <trap+0x85>
    yield();
80105bea:	e8 d1 e4 ff ff       	call   801040c0 <yield>
80105bef:	e9 41 ff ff ff       	jmp    80105b35 <trap+0x85>
80105bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105bf8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105bfb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105bff:	e8 2c de ff ff       	call   80103a30 <cpuid>
80105c04:	57                   	push   %edi
80105c05:	56                   	push   %esi
80105c06:	50                   	push   %eax
80105c07:	68 b4 79 10 80       	push   $0x801079b4
80105c0c:	e8 9f aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105c11:	e8 ca cd ff ff       	call   801029e0 <lapiceoi>
    break;
80105c16:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c19:	e8 32 de ff ff       	call   80103a50 <myproc>
80105c1e:	85 c0                	test   %eax,%eax
80105c20:	0f 85 dd fe ff ff    	jne    80105b03 <trap+0x53>
80105c26:	e9 f2 fe ff ff       	jmp    80105b1d <trap+0x6d>
80105c2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105c30:	e8 1b de ff ff       	call   80103a50 <myproc>
80105c35:	8b 70 24             	mov    0x24(%eax),%esi
80105c38:	85 f6                	test   %esi,%esi
80105c3a:	0f 85 78 01 00 00    	jne    80105db8 <trap+0x308>
    myproc()->tf = tf;
80105c40:	e8 0b de ff ff       	call   80103a50 <myproc>
80105c45:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c48:	e8 33 ef ff ff       	call   80104b80 <syscall>
    if(myproc()->killed)
80105c4d:	e8 fe dd ff ff       	call   80103a50 <myproc>
80105c52:	8b 48 24             	mov    0x24(%eax),%ecx
80105c55:	85 c9                	test   %ecx,%ecx
80105c57:	0f 84 fb fe ff ff    	je     80105b58 <trap+0xa8>
}
80105c5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c60:	5b                   	pop    %ebx
80105c61:	5e                   	pop    %esi
80105c62:	5f                   	pop    %edi
80105c63:	5d                   	pop    %ebp
      exit();
80105c64:	e9 f7 e1 ff ff       	jmp    80103e60 <exit>
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105c70:	e8 3b cc ff ff       	call   801028b0 <kbdintr>
    lapiceoi();
80105c75:	e8 66 cd ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c7a:	e8 d1 dd ff ff       	call   80103a50 <myproc>
80105c7f:	85 c0                	test   %eax,%eax
80105c81:	0f 85 7c fe ff ff    	jne    80105b03 <trap+0x53>
80105c87:	e9 91 fe ff ff       	jmp    80105b1d <trap+0x6d>
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105c90:	e8 eb 02 00 00       	call   80105f80 <uartintr>
    lapiceoi();
80105c95:	e8 46 cd ff ff       	call   801029e0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c9a:	e8 b1 dd ff ff       	call   80103a50 <myproc>
80105c9f:	85 c0                	test   %eax,%eax
80105ca1:	0f 85 5c fe ff ff    	jne    80105b03 <trap+0x53>
80105ca7:	e9 71 fe ff ff       	jmp    80105b1d <trap+0x6d>
80105cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105cb0:	e8 7b c5 ff ff       	call   80102230 <ideintr>
80105cb5:	e9 3b fe ff ff       	jmp    80105af5 <trap+0x45>
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cc0:	0f 20 d6             	mov    %cr2,%esi
    pte_t *pte = walkpgdir(myproc()->pgdir, (void*)va, 0);
80105cc3:	e8 88 dd ff ff       	call   80103a50 <myproc>
  pde = &pgdir[PDX(va)];
80105cc8:	89 f2                	mov    %esi,%edx
  if(*pde & PTE_P){
80105cca:	8b 40 04             	mov    0x4(%eax),%eax
  pde = &pgdir[PDX(va)];
80105ccd:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80105cd0:	8b 04 90             	mov    (%eax,%edx,4),%eax
80105cd3:	a8 01                	test   $0x1,%al
80105cd5:	74 21                	je     80105cf8 <trap+0x248>
  return &pgtab[PTX(va)];
80105cd7:	c1 ee 0a             	shr    $0xa,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105cda:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80105cdf:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80105ce5:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
    if (pte && (*pte & PTE_COW)) {  // Check if it's a COW page
80105cec:	85 f6                	test   %esi,%esi
80105cee:	74 08                	je     80105cf8 <trap+0x248>
80105cf0:	f7 06 00 08 00 00    	testl  $0x800,(%esi)
80105cf6:	75 18                	jne    80105d10 <trap+0x260>
  switch(tf->trapno){
80105cf8:	8b 43 30             	mov    0x30(%ebx),%eax
80105cfb:	e9 d1 fd ff ff       	jmp    80105ad1 <trap+0x21>
    exit();
80105d00:	e8 5b e1 ff ff       	call   80103e60 <exit>
80105d05:	e9 13 fe ff ff       	jmp    80105b1d <trap+0x6d>
80105d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      char *mem = kalloc();
80105d10:	e8 eb c9 ff ff       	call   80102700 <kalloc>
80105d15:	89 c3                	mov    %eax,%ebx
      if (mem == 0)
80105d17:	85 c0                	test   %eax,%eax
80105d19:	0f 84 cb 00 00 00    	je     80105dea <trap+0x33a>
      memmove(mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE); // Copy old page data
80105d1f:	83 ec 04             	sub    $0x4,%esp
80105d22:	68 00 10 00 00       	push   $0x1000
80105d27:	8b 06                	mov    (%esi),%eax
80105d29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105d2e:	05 00 00 00 80       	add    $0x80000000,%eax
80105d33:	50                   	push   %eax
80105d34:	53                   	push   %ebx
      *pte = V2P(mem) | PTE_U | PTE_W | PTE_P; // Update page table entry
80105d35:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80105d3b:	83 cb 07             	or     $0x7,%ebx
      memmove(mem, (char*)P2V(PTE_ADDR(*pte)), PGSIZE); // Copy old page data
80105d3e:	e8 dd ea ff ff       	call   80104820 <memmove>
      acquire(&kmem.lock);
80105d43:	c7 04 24 40 96 14 80 	movl   $0x80149640,(%esp)
80105d4a:	e8 41 e9 ff ff       	call   80104690 <acquire>
      *pte = V2P(mem) | PTE_U | PTE_W | PTE_P; // Update page table entry
80105d4f:	89 1e                	mov    %ebx,(%esi)
      acquire(&kmem.lock);
80105d51:	c7 04 24 40 96 14 80 	movl   $0x80149640,(%esp)
80105d58:	e8 33 e9 ff ff       	call   80104690 <acquire>
      decref((char*)P2V(PTE_ADDR(*pte))); // Decrease reference count of old page
80105d5d:	8b 06                	mov    (%esi),%eax
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105d67:	05 00 00 00 80       	add    $0x80000000,%eax
80105d6c:	89 45 08             	mov    %eax,0x8(%ebp)
}
80105d6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d72:	5b                   	pop    %ebx
80105d73:	5e                   	pop    %esi
80105d74:	5f                   	pop    %edi
80105d75:	5d                   	pop    %ebp
      decref((char*)P2V(PTE_ADDR(*pte))); // Decrease reference count of old page
80105d76:	e9 05 c8 ff ff       	jmp    80102580 <decref>
80105d7b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      acquire(&tickslock);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	68 80 3c 18 80       	push   $0x80183c80
80105d88:	e8 03 e9 ff ff       	call   80104690 <acquire>
      ticks++;
80105d8d:	83 05 60 3c 18 80 01 	addl   $0x1,0x80183c60
      wakeup(&ticks);
80105d94:	c7 04 24 60 3c 18 80 	movl   $0x80183c60,(%esp)
80105d9b:	e8 30 e4 ff ff       	call   801041d0 <wakeup>
      release(&tickslock);
80105da0:	c7 04 24 80 3c 18 80 	movl   $0x80183c80,(%esp)
80105da7:	e8 84 e8 ff ff       	call   80104630 <release>
80105dac:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105daf:	e9 41 fd ff ff       	jmp    80105af5 <trap+0x45>
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105db8:	e8 a3 e0 ff ff       	call   80103e60 <exit>
80105dbd:	e9 7e fe ff ff       	jmp    80105c40 <trap+0x190>
80105dc2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105dc5:	e8 66 dc ff ff       	call   80103a30 <cpuid>
80105dca:	83 ec 0c             	sub    $0xc,%esp
80105dcd:	56                   	push   %esi
80105dce:	57                   	push   %edi
80105dcf:	50                   	push   %eax
80105dd0:	ff 73 30             	push   0x30(%ebx)
80105dd3:	68 d8 79 10 80       	push   $0x801079d8
80105dd8:	e8 d3 a8 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105ddd:	83 c4 14             	add    $0x14,%esp
80105de0:	68 c1 77 10 80       	push   $0x801077c1
80105de5:	e8 96 a5 ff ff       	call   80100380 <panic>
        panic("Out of memory");
80105dea:	83 ec 0c             	sub    $0xc,%esp
80105ded:	68 b3 77 10 80       	push   $0x801077b3
80105df2:	e8 89 a5 ff ff       	call   80100380 <panic>
80105df7:	66 90                	xchg   %ax,%ax
80105df9:	66 90                	xchg   %ax,%ax
80105dfb:	66 90                	xchg   %ax,%ax
80105dfd:	66 90                	xchg   %ax,%ax
80105dff:	90                   	nop

80105e00 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e00:	a1 c0 44 18 80       	mov    0x801844c0,%eax
80105e05:	85 c0                	test   %eax,%eax
80105e07:	74 17                	je     80105e20 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e09:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e0e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e0f:	a8 01                	test   $0x1,%al
80105e11:	74 0d                	je     80105e20 <uartgetc+0x20>
80105e13:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e18:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e19:	0f b6 c0             	movzbl %al,%eax
80105e1c:	c3                   	ret
80105e1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e25:	c3                   	ret
80105e26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105e2d:	00 
80105e2e:	66 90                	xchg   %ax,%ax

80105e30 <uartinit>:
{
80105e30:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e31:	31 c9                	xor    %ecx,%ecx
80105e33:	89 c8                	mov    %ecx,%eax
80105e35:	89 e5                	mov    %esp,%ebp
80105e37:	57                   	push   %edi
80105e38:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e3d:	56                   	push   %esi
80105e3e:	89 fa                	mov    %edi,%edx
80105e40:	53                   	push   %ebx
80105e41:	83 ec 1c             	sub    $0x1c,%esp
80105e44:	ee                   	out    %al,(%dx)
80105e45:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e4f:	89 f2                	mov    %esi,%edx
80105e51:	ee                   	out    %al,(%dx)
80105e52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e5c:	ee                   	out    %al,(%dx)
80105e5d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e62:	89 c8                	mov    %ecx,%eax
80105e64:	89 da                	mov    %ebx,%edx
80105e66:	ee                   	out    %al,(%dx)
80105e67:	b8 03 00 00 00       	mov    $0x3,%eax
80105e6c:	89 f2                	mov    %esi,%edx
80105e6e:	ee                   	out    %al,(%dx)
80105e6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e74:	89 c8                	mov    %ecx,%eax
80105e76:	ee                   	out    %al,(%dx)
80105e77:	b8 01 00 00 00       	mov    $0x1,%eax
80105e7c:	89 da                	mov    %ebx,%edx
80105e7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e84:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e85:	3c ff                	cmp    $0xff,%al
80105e87:	0f 84 7c 00 00 00    	je     80105f09 <uartinit+0xd9>
  uart = 1;
80105e8d:	c7 05 c0 44 18 80 01 	movl   $0x1,0x801844c0
80105e94:	00 00 00 
80105e97:	89 fa                	mov    %edi,%edx
80105e99:	ec                   	in     (%dx),%al
80105e9a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e9f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105ea0:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105ea3:	bf c6 77 10 80       	mov    $0x801077c6,%edi
80105ea8:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105ead:	6a 00                	push   $0x0
80105eaf:	6a 04                	push   $0x4
80105eb1:	e8 aa c5 ff ff       	call   80102460 <ioapicenable>
80105eb6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105eb9:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105ebd:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105ec0:	a1 c0 44 18 80       	mov    0x801844c0,%eax
80105ec5:	85 c0                	test   %eax,%eax
80105ec7:	74 32                	je     80105efb <uartinit+0xcb>
80105ec9:	89 f2                	mov    %esi,%edx
80105ecb:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ecc:	a8 20                	test   $0x20,%al
80105ece:	75 21                	jne    80105ef1 <uartinit+0xc1>
80105ed0:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ed5:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105ed8:	83 ec 0c             	sub    $0xc,%esp
80105edb:	6a 0a                	push   $0xa
80105edd:	e8 1e cb ff ff       	call   80102a00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	83 eb 01             	sub    $0x1,%ebx
80105ee8:	74 07                	je     80105ef1 <uartinit+0xc1>
80105eea:	89 f2                	mov    %esi,%edx
80105eec:	ec                   	in     (%dx),%al
80105eed:	a8 20                	test   $0x20,%al
80105eef:	74 e7                	je     80105ed8 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ef1:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ef6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105efa:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105efb:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105eff:	83 c7 01             	add    $0x1,%edi
80105f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80105f05:	84 c0                	test   %al,%al
80105f07:	75 b7                	jne    80105ec0 <uartinit+0x90>
}
80105f09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f0c:	5b                   	pop    %ebx
80105f0d:	5e                   	pop    %esi
80105f0e:	5f                   	pop    %edi
80105f0f:	5d                   	pop    %ebp
80105f10:	c3                   	ret
80105f11:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105f18:	00 
80105f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f20 <uartputc>:
  if(!uart)
80105f20:	a1 c0 44 18 80       	mov    0x801844c0,%eax
80105f25:	85 c0                	test   %eax,%eax
80105f27:	74 4f                	je     80105f78 <uartputc+0x58>
{
80105f29:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f2a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f2f:	89 e5                	mov    %esp,%ebp
80105f31:	56                   	push   %esi
80105f32:	53                   	push   %ebx
80105f33:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f34:	a8 20                	test   $0x20,%al
80105f36:	75 29                	jne    80105f61 <uartputc+0x41>
80105f38:	bb 80 00 00 00       	mov    $0x80,%ebx
80105f3d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105f42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105f48:	83 ec 0c             	sub    $0xc,%esp
80105f4b:	6a 0a                	push   $0xa
80105f4d:	e8 ae ca ff ff       	call   80102a00 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	83 eb 01             	sub    $0x1,%ebx
80105f58:	74 07                	je     80105f61 <uartputc+0x41>
80105f5a:	89 f2                	mov    %esi,%edx
80105f5c:	ec                   	in     (%dx),%al
80105f5d:	a8 20                	test   $0x20,%al
80105f5f:	74 e7                	je     80105f48 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105f61:	8b 45 08             	mov    0x8(%ebp),%eax
80105f64:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f69:	ee                   	out    %al,(%dx)
}
80105f6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f6d:	5b                   	pop    %ebx
80105f6e:	5e                   	pop    %esi
80105f6f:	5d                   	pop    %ebp
80105f70:	c3                   	ret
80105f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f78:	c3                   	ret
80105f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f80 <uartintr>:

void
uartintr(void)
{
80105f80:	55                   	push   %ebp
80105f81:	89 e5                	mov    %esp,%ebp
80105f83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f86:	68 00 5e 10 80       	push   $0x80105e00
80105f8b:	e8 10 a9 ff ff       	call   801008a0 <consoleintr>
}
80105f90:	83 c4 10             	add    $0x10,%esp
80105f93:	c9                   	leave
80105f94:	c3                   	ret

80105f95 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $0
80105f97:	6a 00                	push   $0x0
  jmp alltraps
80105f99:	e9 3c fa ff ff       	jmp    801059da <alltraps>

80105f9e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $1
80105fa0:	6a 01                	push   $0x1
  jmp alltraps
80105fa2:	e9 33 fa ff ff       	jmp    801059da <alltraps>

80105fa7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $2
80105fa9:	6a 02                	push   $0x2
  jmp alltraps
80105fab:	e9 2a fa ff ff       	jmp    801059da <alltraps>

80105fb0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $3
80105fb2:	6a 03                	push   $0x3
  jmp alltraps
80105fb4:	e9 21 fa ff ff       	jmp    801059da <alltraps>

80105fb9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $4
80105fbb:	6a 04                	push   $0x4
  jmp alltraps
80105fbd:	e9 18 fa ff ff       	jmp    801059da <alltraps>

80105fc2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $5
80105fc4:	6a 05                	push   $0x5
  jmp alltraps
80105fc6:	e9 0f fa ff ff       	jmp    801059da <alltraps>

80105fcb <vector6>:
.globl vector6
vector6:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $6
80105fcd:	6a 06                	push   $0x6
  jmp alltraps
80105fcf:	e9 06 fa ff ff       	jmp    801059da <alltraps>

80105fd4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $7
80105fd6:	6a 07                	push   $0x7
  jmp alltraps
80105fd8:	e9 fd f9 ff ff       	jmp    801059da <alltraps>

80105fdd <vector8>:
.globl vector8
vector8:
  pushl $8
80105fdd:	6a 08                	push   $0x8
  jmp alltraps
80105fdf:	e9 f6 f9 ff ff       	jmp    801059da <alltraps>

80105fe4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $9
80105fe6:	6a 09                	push   $0x9
  jmp alltraps
80105fe8:	e9 ed f9 ff ff       	jmp    801059da <alltraps>

80105fed <vector10>:
.globl vector10
vector10:
  pushl $10
80105fed:	6a 0a                	push   $0xa
  jmp alltraps
80105fef:	e9 e6 f9 ff ff       	jmp    801059da <alltraps>

80105ff4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105ff4:	6a 0b                	push   $0xb
  jmp alltraps
80105ff6:	e9 df f9 ff ff       	jmp    801059da <alltraps>

80105ffb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ffb:	6a 0c                	push   $0xc
  jmp alltraps
80105ffd:	e9 d8 f9 ff ff       	jmp    801059da <alltraps>

80106002 <vector13>:
.globl vector13
vector13:
  pushl $13
80106002:	6a 0d                	push   $0xd
  jmp alltraps
80106004:	e9 d1 f9 ff ff       	jmp    801059da <alltraps>

80106009 <vector14>:
.globl vector14
vector14:
  pushl $14
80106009:	6a 0e                	push   $0xe
  jmp alltraps
8010600b:	e9 ca f9 ff ff       	jmp    801059da <alltraps>

80106010 <vector15>:
.globl vector15
vector15:
  pushl $0
80106010:	6a 00                	push   $0x0
  pushl $15
80106012:	6a 0f                	push   $0xf
  jmp alltraps
80106014:	e9 c1 f9 ff ff       	jmp    801059da <alltraps>

80106019 <vector16>:
.globl vector16
vector16:
  pushl $0
80106019:	6a 00                	push   $0x0
  pushl $16
8010601b:	6a 10                	push   $0x10
  jmp alltraps
8010601d:	e9 b8 f9 ff ff       	jmp    801059da <alltraps>

80106022 <vector17>:
.globl vector17
vector17:
  pushl $17
80106022:	6a 11                	push   $0x11
  jmp alltraps
80106024:	e9 b1 f9 ff ff       	jmp    801059da <alltraps>

80106029 <vector18>:
.globl vector18
vector18:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $18
8010602b:	6a 12                	push   $0x12
  jmp alltraps
8010602d:	e9 a8 f9 ff ff       	jmp    801059da <alltraps>

80106032 <vector19>:
.globl vector19
vector19:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $19
80106034:	6a 13                	push   $0x13
  jmp alltraps
80106036:	e9 9f f9 ff ff       	jmp    801059da <alltraps>

8010603b <vector20>:
.globl vector20
vector20:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $20
8010603d:	6a 14                	push   $0x14
  jmp alltraps
8010603f:	e9 96 f9 ff ff       	jmp    801059da <alltraps>

80106044 <vector21>:
.globl vector21
vector21:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $21
80106046:	6a 15                	push   $0x15
  jmp alltraps
80106048:	e9 8d f9 ff ff       	jmp    801059da <alltraps>

8010604d <vector22>:
.globl vector22
vector22:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $22
8010604f:	6a 16                	push   $0x16
  jmp alltraps
80106051:	e9 84 f9 ff ff       	jmp    801059da <alltraps>

80106056 <vector23>:
.globl vector23
vector23:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $23
80106058:	6a 17                	push   $0x17
  jmp alltraps
8010605a:	e9 7b f9 ff ff       	jmp    801059da <alltraps>

8010605f <vector24>:
.globl vector24
vector24:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $24
80106061:	6a 18                	push   $0x18
  jmp alltraps
80106063:	e9 72 f9 ff ff       	jmp    801059da <alltraps>

80106068 <vector25>:
.globl vector25
vector25:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $25
8010606a:	6a 19                	push   $0x19
  jmp alltraps
8010606c:	e9 69 f9 ff ff       	jmp    801059da <alltraps>

80106071 <vector26>:
.globl vector26
vector26:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $26
80106073:	6a 1a                	push   $0x1a
  jmp alltraps
80106075:	e9 60 f9 ff ff       	jmp    801059da <alltraps>

8010607a <vector27>:
.globl vector27
vector27:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $27
8010607c:	6a 1b                	push   $0x1b
  jmp alltraps
8010607e:	e9 57 f9 ff ff       	jmp    801059da <alltraps>

80106083 <vector28>:
.globl vector28
vector28:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $28
80106085:	6a 1c                	push   $0x1c
  jmp alltraps
80106087:	e9 4e f9 ff ff       	jmp    801059da <alltraps>

8010608c <vector29>:
.globl vector29
vector29:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $29
8010608e:	6a 1d                	push   $0x1d
  jmp alltraps
80106090:	e9 45 f9 ff ff       	jmp    801059da <alltraps>

80106095 <vector30>:
.globl vector30
vector30:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $30
80106097:	6a 1e                	push   $0x1e
  jmp alltraps
80106099:	e9 3c f9 ff ff       	jmp    801059da <alltraps>

8010609e <vector31>:
.globl vector31
vector31:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $31
801060a0:	6a 1f                	push   $0x1f
  jmp alltraps
801060a2:	e9 33 f9 ff ff       	jmp    801059da <alltraps>

801060a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $32
801060a9:	6a 20                	push   $0x20
  jmp alltraps
801060ab:	e9 2a f9 ff ff       	jmp    801059da <alltraps>

801060b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060b0:	6a 00                	push   $0x0
  pushl $33
801060b2:	6a 21                	push   $0x21
  jmp alltraps
801060b4:	e9 21 f9 ff ff       	jmp    801059da <alltraps>

801060b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060b9:	6a 00                	push   $0x0
  pushl $34
801060bb:	6a 22                	push   $0x22
  jmp alltraps
801060bd:	e9 18 f9 ff ff       	jmp    801059da <alltraps>

801060c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801060c2:	6a 00                	push   $0x0
  pushl $35
801060c4:	6a 23                	push   $0x23
  jmp alltraps
801060c6:	e9 0f f9 ff ff       	jmp    801059da <alltraps>

801060cb <vector36>:
.globl vector36
vector36:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $36
801060cd:	6a 24                	push   $0x24
  jmp alltraps
801060cf:	e9 06 f9 ff ff       	jmp    801059da <alltraps>

801060d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801060d4:	6a 00                	push   $0x0
  pushl $37
801060d6:	6a 25                	push   $0x25
  jmp alltraps
801060d8:	e9 fd f8 ff ff       	jmp    801059da <alltraps>

801060dd <vector38>:
.globl vector38
vector38:
  pushl $0
801060dd:	6a 00                	push   $0x0
  pushl $38
801060df:	6a 26                	push   $0x26
  jmp alltraps
801060e1:	e9 f4 f8 ff ff       	jmp    801059da <alltraps>

801060e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801060e6:	6a 00                	push   $0x0
  pushl $39
801060e8:	6a 27                	push   $0x27
  jmp alltraps
801060ea:	e9 eb f8 ff ff       	jmp    801059da <alltraps>

801060ef <vector40>:
.globl vector40
vector40:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $40
801060f1:	6a 28                	push   $0x28
  jmp alltraps
801060f3:	e9 e2 f8 ff ff       	jmp    801059da <alltraps>

801060f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801060f8:	6a 00                	push   $0x0
  pushl $41
801060fa:	6a 29                	push   $0x29
  jmp alltraps
801060fc:	e9 d9 f8 ff ff       	jmp    801059da <alltraps>

80106101 <vector42>:
.globl vector42
vector42:
  pushl $0
80106101:	6a 00                	push   $0x0
  pushl $42
80106103:	6a 2a                	push   $0x2a
  jmp alltraps
80106105:	e9 d0 f8 ff ff       	jmp    801059da <alltraps>

8010610a <vector43>:
.globl vector43
vector43:
  pushl $0
8010610a:	6a 00                	push   $0x0
  pushl $43
8010610c:	6a 2b                	push   $0x2b
  jmp alltraps
8010610e:	e9 c7 f8 ff ff       	jmp    801059da <alltraps>

80106113 <vector44>:
.globl vector44
vector44:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $44
80106115:	6a 2c                	push   $0x2c
  jmp alltraps
80106117:	e9 be f8 ff ff       	jmp    801059da <alltraps>

8010611c <vector45>:
.globl vector45
vector45:
  pushl $0
8010611c:	6a 00                	push   $0x0
  pushl $45
8010611e:	6a 2d                	push   $0x2d
  jmp alltraps
80106120:	e9 b5 f8 ff ff       	jmp    801059da <alltraps>

80106125 <vector46>:
.globl vector46
vector46:
  pushl $0
80106125:	6a 00                	push   $0x0
  pushl $46
80106127:	6a 2e                	push   $0x2e
  jmp alltraps
80106129:	e9 ac f8 ff ff       	jmp    801059da <alltraps>

8010612e <vector47>:
.globl vector47
vector47:
  pushl $0
8010612e:	6a 00                	push   $0x0
  pushl $47
80106130:	6a 2f                	push   $0x2f
  jmp alltraps
80106132:	e9 a3 f8 ff ff       	jmp    801059da <alltraps>

80106137 <vector48>:
.globl vector48
vector48:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $48
80106139:	6a 30                	push   $0x30
  jmp alltraps
8010613b:	e9 9a f8 ff ff       	jmp    801059da <alltraps>

80106140 <vector49>:
.globl vector49
vector49:
  pushl $0
80106140:	6a 00                	push   $0x0
  pushl $49
80106142:	6a 31                	push   $0x31
  jmp alltraps
80106144:	e9 91 f8 ff ff       	jmp    801059da <alltraps>

80106149 <vector50>:
.globl vector50
vector50:
  pushl $0
80106149:	6a 00                	push   $0x0
  pushl $50
8010614b:	6a 32                	push   $0x32
  jmp alltraps
8010614d:	e9 88 f8 ff ff       	jmp    801059da <alltraps>

80106152 <vector51>:
.globl vector51
vector51:
  pushl $0
80106152:	6a 00                	push   $0x0
  pushl $51
80106154:	6a 33                	push   $0x33
  jmp alltraps
80106156:	e9 7f f8 ff ff       	jmp    801059da <alltraps>

8010615b <vector52>:
.globl vector52
vector52:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $52
8010615d:	6a 34                	push   $0x34
  jmp alltraps
8010615f:	e9 76 f8 ff ff       	jmp    801059da <alltraps>

80106164 <vector53>:
.globl vector53
vector53:
  pushl $0
80106164:	6a 00                	push   $0x0
  pushl $53
80106166:	6a 35                	push   $0x35
  jmp alltraps
80106168:	e9 6d f8 ff ff       	jmp    801059da <alltraps>

8010616d <vector54>:
.globl vector54
vector54:
  pushl $0
8010616d:	6a 00                	push   $0x0
  pushl $54
8010616f:	6a 36                	push   $0x36
  jmp alltraps
80106171:	e9 64 f8 ff ff       	jmp    801059da <alltraps>

80106176 <vector55>:
.globl vector55
vector55:
  pushl $0
80106176:	6a 00                	push   $0x0
  pushl $55
80106178:	6a 37                	push   $0x37
  jmp alltraps
8010617a:	e9 5b f8 ff ff       	jmp    801059da <alltraps>

8010617f <vector56>:
.globl vector56
vector56:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $56
80106181:	6a 38                	push   $0x38
  jmp alltraps
80106183:	e9 52 f8 ff ff       	jmp    801059da <alltraps>

80106188 <vector57>:
.globl vector57
vector57:
  pushl $0
80106188:	6a 00                	push   $0x0
  pushl $57
8010618a:	6a 39                	push   $0x39
  jmp alltraps
8010618c:	e9 49 f8 ff ff       	jmp    801059da <alltraps>

80106191 <vector58>:
.globl vector58
vector58:
  pushl $0
80106191:	6a 00                	push   $0x0
  pushl $58
80106193:	6a 3a                	push   $0x3a
  jmp alltraps
80106195:	e9 40 f8 ff ff       	jmp    801059da <alltraps>

8010619a <vector59>:
.globl vector59
vector59:
  pushl $0
8010619a:	6a 00                	push   $0x0
  pushl $59
8010619c:	6a 3b                	push   $0x3b
  jmp alltraps
8010619e:	e9 37 f8 ff ff       	jmp    801059da <alltraps>

801061a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $60
801061a5:	6a 3c                	push   $0x3c
  jmp alltraps
801061a7:	e9 2e f8 ff ff       	jmp    801059da <alltraps>

801061ac <vector61>:
.globl vector61
vector61:
  pushl $0
801061ac:	6a 00                	push   $0x0
  pushl $61
801061ae:	6a 3d                	push   $0x3d
  jmp alltraps
801061b0:	e9 25 f8 ff ff       	jmp    801059da <alltraps>

801061b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061b5:	6a 00                	push   $0x0
  pushl $62
801061b7:	6a 3e                	push   $0x3e
  jmp alltraps
801061b9:	e9 1c f8 ff ff       	jmp    801059da <alltraps>

801061be <vector63>:
.globl vector63
vector63:
  pushl $0
801061be:	6a 00                	push   $0x0
  pushl $63
801061c0:	6a 3f                	push   $0x3f
  jmp alltraps
801061c2:	e9 13 f8 ff ff       	jmp    801059da <alltraps>

801061c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $64
801061c9:	6a 40                	push   $0x40
  jmp alltraps
801061cb:	e9 0a f8 ff ff       	jmp    801059da <alltraps>

801061d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801061d0:	6a 00                	push   $0x0
  pushl $65
801061d2:	6a 41                	push   $0x41
  jmp alltraps
801061d4:	e9 01 f8 ff ff       	jmp    801059da <alltraps>

801061d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801061d9:	6a 00                	push   $0x0
  pushl $66
801061db:	6a 42                	push   $0x42
  jmp alltraps
801061dd:	e9 f8 f7 ff ff       	jmp    801059da <alltraps>

801061e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801061e2:	6a 00                	push   $0x0
  pushl $67
801061e4:	6a 43                	push   $0x43
  jmp alltraps
801061e6:	e9 ef f7 ff ff       	jmp    801059da <alltraps>

801061eb <vector68>:
.globl vector68
vector68:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $68
801061ed:	6a 44                	push   $0x44
  jmp alltraps
801061ef:	e9 e6 f7 ff ff       	jmp    801059da <alltraps>

801061f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801061f4:	6a 00                	push   $0x0
  pushl $69
801061f6:	6a 45                	push   $0x45
  jmp alltraps
801061f8:	e9 dd f7 ff ff       	jmp    801059da <alltraps>

801061fd <vector70>:
.globl vector70
vector70:
  pushl $0
801061fd:	6a 00                	push   $0x0
  pushl $70
801061ff:	6a 46                	push   $0x46
  jmp alltraps
80106201:	e9 d4 f7 ff ff       	jmp    801059da <alltraps>

80106206 <vector71>:
.globl vector71
vector71:
  pushl $0
80106206:	6a 00                	push   $0x0
  pushl $71
80106208:	6a 47                	push   $0x47
  jmp alltraps
8010620a:	e9 cb f7 ff ff       	jmp    801059da <alltraps>

8010620f <vector72>:
.globl vector72
vector72:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $72
80106211:	6a 48                	push   $0x48
  jmp alltraps
80106213:	e9 c2 f7 ff ff       	jmp    801059da <alltraps>

80106218 <vector73>:
.globl vector73
vector73:
  pushl $0
80106218:	6a 00                	push   $0x0
  pushl $73
8010621a:	6a 49                	push   $0x49
  jmp alltraps
8010621c:	e9 b9 f7 ff ff       	jmp    801059da <alltraps>

80106221 <vector74>:
.globl vector74
vector74:
  pushl $0
80106221:	6a 00                	push   $0x0
  pushl $74
80106223:	6a 4a                	push   $0x4a
  jmp alltraps
80106225:	e9 b0 f7 ff ff       	jmp    801059da <alltraps>

8010622a <vector75>:
.globl vector75
vector75:
  pushl $0
8010622a:	6a 00                	push   $0x0
  pushl $75
8010622c:	6a 4b                	push   $0x4b
  jmp alltraps
8010622e:	e9 a7 f7 ff ff       	jmp    801059da <alltraps>

80106233 <vector76>:
.globl vector76
vector76:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $76
80106235:	6a 4c                	push   $0x4c
  jmp alltraps
80106237:	e9 9e f7 ff ff       	jmp    801059da <alltraps>

8010623c <vector77>:
.globl vector77
vector77:
  pushl $0
8010623c:	6a 00                	push   $0x0
  pushl $77
8010623e:	6a 4d                	push   $0x4d
  jmp alltraps
80106240:	e9 95 f7 ff ff       	jmp    801059da <alltraps>

80106245 <vector78>:
.globl vector78
vector78:
  pushl $0
80106245:	6a 00                	push   $0x0
  pushl $78
80106247:	6a 4e                	push   $0x4e
  jmp alltraps
80106249:	e9 8c f7 ff ff       	jmp    801059da <alltraps>

8010624e <vector79>:
.globl vector79
vector79:
  pushl $0
8010624e:	6a 00                	push   $0x0
  pushl $79
80106250:	6a 4f                	push   $0x4f
  jmp alltraps
80106252:	e9 83 f7 ff ff       	jmp    801059da <alltraps>

80106257 <vector80>:
.globl vector80
vector80:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $80
80106259:	6a 50                	push   $0x50
  jmp alltraps
8010625b:	e9 7a f7 ff ff       	jmp    801059da <alltraps>

80106260 <vector81>:
.globl vector81
vector81:
  pushl $0
80106260:	6a 00                	push   $0x0
  pushl $81
80106262:	6a 51                	push   $0x51
  jmp alltraps
80106264:	e9 71 f7 ff ff       	jmp    801059da <alltraps>

80106269 <vector82>:
.globl vector82
vector82:
  pushl $0
80106269:	6a 00                	push   $0x0
  pushl $82
8010626b:	6a 52                	push   $0x52
  jmp alltraps
8010626d:	e9 68 f7 ff ff       	jmp    801059da <alltraps>

80106272 <vector83>:
.globl vector83
vector83:
  pushl $0
80106272:	6a 00                	push   $0x0
  pushl $83
80106274:	6a 53                	push   $0x53
  jmp alltraps
80106276:	e9 5f f7 ff ff       	jmp    801059da <alltraps>

8010627b <vector84>:
.globl vector84
vector84:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $84
8010627d:	6a 54                	push   $0x54
  jmp alltraps
8010627f:	e9 56 f7 ff ff       	jmp    801059da <alltraps>

80106284 <vector85>:
.globl vector85
vector85:
  pushl $0
80106284:	6a 00                	push   $0x0
  pushl $85
80106286:	6a 55                	push   $0x55
  jmp alltraps
80106288:	e9 4d f7 ff ff       	jmp    801059da <alltraps>

8010628d <vector86>:
.globl vector86
vector86:
  pushl $0
8010628d:	6a 00                	push   $0x0
  pushl $86
8010628f:	6a 56                	push   $0x56
  jmp alltraps
80106291:	e9 44 f7 ff ff       	jmp    801059da <alltraps>

80106296 <vector87>:
.globl vector87
vector87:
  pushl $0
80106296:	6a 00                	push   $0x0
  pushl $87
80106298:	6a 57                	push   $0x57
  jmp alltraps
8010629a:	e9 3b f7 ff ff       	jmp    801059da <alltraps>

8010629f <vector88>:
.globl vector88
vector88:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $88
801062a1:	6a 58                	push   $0x58
  jmp alltraps
801062a3:	e9 32 f7 ff ff       	jmp    801059da <alltraps>

801062a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062a8:	6a 00                	push   $0x0
  pushl $89
801062aa:	6a 59                	push   $0x59
  jmp alltraps
801062ac:	e9 29 f7 ff ff       	jmp    801059da <alltraps>

801062b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062b1:	6a 00                	push   $0x0
  pushl $90
801062b3:	6a 5a                	push   $0x5a
  jmp alltraps
801062b5:	e9 20 f7 ff ff       	jmp    801059da <alltraps>

801062ba <vector91>:
.globl vector91
vector91:
  pushl $0
801062ba:	6a 00                	push   $0x0
  pushl $91
801062bc:	6a 5b                	push   $0x5b
  jmp alltraps
801062be:	e9 17 f7 ff ff       	jmp    801059da <alltraps>

801062c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $92
801062c5:	6a 5c                	push   $0x5c
  jmp alltraps
801062c7:	e9 0e f7 ff ff       	jmp    801059da <alltraps>

801062cc <vector93>:
.globl vector93
vector93:
  pushl $0
801062cc:	6a 00                	push   $0x0
  pushl $93
801062ce:	6a 5d                	push   $0x5d
  jmp alltraps
801062d0:	e9 05 f7 ff ff       	jmp    801059da <alltraps>

801062d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801062d5:	6a 00                	push   $0x0
  pushl $94
801062d7:	6a 5e                	push   $0x5e
  jmp alltraps
801062d9:	e9 fc f6 ff ff       	jmp    801059da <alltraps>

801062de <vector95>:
.globl vector95
vector95:
  pushl $0
801062de:	6a 00                	push   $0x0
  pushl $95
801062e0:	6a 5f                	push   $0x5f
  jmp alltraps
801062e2:	e9 f3 f6 ff ff       	jmp    801059da <alltraps>

801062e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $96
801062e9:	6a 60                	push   $0x60
  jmp alltraps
801062eb:	e9 ea f6 ff ff       	jmp    801059da <alltraps>

801062f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801062f0:	6a 00                	push   $0x0
  pushl $97
801062f2:	6a 61                	push   $0x61
  jmp alltraps
801062f4:	e9 e1 f6 ff ff       	jmp    801059da <alltraps>

801062f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801062f9:	6a 00                	push   $0x0
  pushl $98
801062fb:	6a 62                	push   $0x62
  jmp alltraps
801062fd:	e9 d8 f6 ff ff       	jmp    801059da <alltraps>

80106302 <vector99>:
.globl vector99
vector99:
  pushl $0
80106302:	6a 00                	push   $0x0
  pushl $99
80106304:	6a 63                	push   $0x63
  jmp alltraps
80106306:	e9 cf f6 ff ff       	jmp    801059da <alltraps>

8010630b <vector100>:
.globl vector100
vector100:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $100
8010630d:	6a 64                	push   $0x64
  jmp alltraps
8010630f:	e9 c6 f6 ff ff       	jmp    801059da <alltraps>

80106314 <vector101>:
.globl vector101
vector101:
  pushl $0
80106314:	6a 00                	push   $0x0
  pushl $101
80106316:	6a 65                	push   $0x65
  jmp alltraps
80106318:	e9 bd f6 ff ff       	jmp    801059da <alltraps>

8010631d <vector102>:
.globl vector102
vector102:
  pushl $0
8010631d:	6a 00                	push   $0x0
  pushl $102
8010631f:	6a 66                	push   $0x66
  jmp alltraps
80106321:	e9 b4 f6 ff ff       	jmp    801059da <alltraps>

80106326 <vector103>:
.globl vector103
vector103:
  pushl $0
80106326:	6a 00                	push   $0x0
  pushl $103
80106328:	6a 67                	push   $0x67
  jmp alltraps
8010632a:	e9 ab f6 ff ff       	jmp    801059da <alltraps>

8010632f <vector104>:
.globl vector104
vector104:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $104
80106331:	6a 68                	push   $0x68
  jmp alltraps
80106333:	e9 a2 f6 ff ff       	jmp    801059da <alltraps>

80106338 <vector105>:
.globl vector105
vector105:
  pushl $0
80106338:	6a 00                	push   $0x0
  pushl $105
8010633a:	6a 69                	push   $0x69
  jmp alltraps
8010633c:	e9 99 f6 ff ff       	jmp    801059da <alltraps>

80106341 <vector106>:
.globl vector106
vector106:
  pushl $0
80106341:	6a 00                	push   $0x0
  pushl $106
80106343:	6a 6a                	push   $0x6a
  jmp alltraps
80106345:	e9 90 f6 ff ff       	jmp    801059da <alltraps>

8010634a <vector107>:
.globl vector107
vector107:
  pushl $0
8010634a:	6a 00                	push   $0x0
  pushl $107
8010634c:	6a 6b                	push   $0x6b
  jmp alltraps
8010634e:	e9 87 f6 ff ff       	jmp    801059da <alltraps>

80106353 <vector108>:
.globl vector108
vector108:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $108
80106355:	6a 6c                	push   $0x6c
  jmp alltraps
80106357:	e9 7e f6 ff ff       	jmp    801059da <alltraps>

8010635c <vector109>:
.globl vector109
vector109:
  pushl $0
8010635c:	6a 00                	push   $0x0
  pushl $109
8010635e:	6a 6d                	push   $0x6d
  jmp alltraps
80106360:	e9 75 f6 ff ff       	jmp    801059da <alltraps>

80106365 <vector110>:
.globl vector110
vector110:
  pushl $0
80106365:	6a 00                	push   $0x0
  pushl $110
80106367:	6a 6e                	push   $0x6e
  jmp alltraps
80106369:	e9 6c f6 ff ff       	jmp    801059da <alltraps>

8010636e <vector111>:
.globl vector111
vector111:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $111
80106370:	6a 6f                	push   $0x6f
  jmp alltraps
80106372:	e9 63 f6 ff ff       	jmp    801059da <alltraps>

80106377 <vector112>:
.globl vector112
vector112:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $112
80106379:	6a 70                	push   $0x70
  jmp alltraps
8010637b:	e9 5a f6 ff ff       	jmp    801059da <alltraps>

80106380 <vector113>:
.globl vector113
vector113:
  pushl $0
80106380:	6a 00                	push   $0x0
  pushl $113
80106382:	6a 71                	push   $0x71
  jmp alltraps
80106384:	e9 51 f6 ff ff       	jmp    801059da <alltraps>

80106389 <vector114>:
.globl vector114
vector114:
  pushl $0
80106389:	6a 00                	push   $0x0
  pushl $114
8010638b:	6a 72                	push   $0x72
  jmp alltraps
8010638d:	e9 48 f6 ff ff       	jmp    801059da <alltraps>

80106392 <vector115>:
.globl vector115
vector115:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $115
80106394:	6a 73                	push   $0x73
  jmp alltraps
80106396:	e9 3f f6 ff ff       	jmp    801059da <alltraps>

8010639b <vector116>:
.globl vector116
vector116:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $116
8010639d:	6a 74                	push   $0x74
  jmp alltraps
8010639f:	e9 36 f6 ff ff       	jmp    801059da <alltraps>

801063a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063a4:	6a 00                	push   $0x0
  pushl $117
801063a6:	6a 75                	push   $0x75
  jmp alltraps
801063a8:	e9 2d f6 ff ff       	jmp    801059da <alltraps>

801063ad <vector118>:
.globl vector118
vector118:
  pushl $0
801063ad:	6a 00                	push   $0x0
  pushl $118
801063af:	6a 76                	push   $0x76
  jmp alltraps
801063b1:	e9 24 f6 ff ff       	jmp    801059da <alltraps>

801063b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $119
801063b8:	6a 77                	push   $0x77
  jmp alltraps
801063ba:	e9 1b f6 ff ff       	jmp    801059da <alltraps>

801063bf <vector120>:
.globl vector120
vector120:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $120
801063c1:	6a 78                	push   $0x78
  jmp alltraps
801063c3:	e9 12 f6 ff ff       	jmp    801059da <alltraps>

801063c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801063c8:	6a 00                	push   $0x0
  pushl $121
801063ca:	6a 79                	push   $0x79
  jmp alltraps
801063cc:	e9 09 f6 ff ff       	jmp    801059da <alltraps>

801063d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801063d1:	6a 00                	push   $0x0
  pushl $122
801063d3:	6a 7a                	push   $0x7a
  jmp alltraps
801063d5:	e9 00 f6 ff ff       	jmp    801059da <alltraps>

801063da <vector123>:
.globl vector123
vector123:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $123
801063dc:	6a 7b                	push   $0x7b
  jmp alltraps
801063de:	e9 f7 f5 ff ff       	jmp    801059da <alltraps>

801063e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $124
801063e5:	6a 7c                	push   $0x7c
  jmp alltraps
801063e7:	e9 ee f5 ff ff       	jmp    801059da <alltraps>

801063ec <vector125>:
.globl vector125
vector125:
  pushl $0
801063ec:	6a 00                	push   $0x0
  pushl $125
801063ee:	6a 7d                	push   $0x7d
  jmp alltraps
801063f0:	e9 e5 f5 ff ff       	jmp    801059da <alltraps>

801063f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801063f5:	6a 00                	push   $0x0
  pushl $126
801063f7:	6a 7e                	push   $0x7e
  jmp alltraps
801063f9:	e9 dc f5 ff ff       	jmp    801059da <alltraps>

801063fe <vector127>:
.globl vector127
vector127:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $127
80106400:	6a 7f                	push   $0x7f
  jmp alltraps
80106402:	e9 d3 f5 ff ff       	jmp    801059da <alltraps>

80106407 <vector128>:
.globl vector128
vector128:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $128
80106409:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010640e:	e9 c7 f5 ff ff       	jmp    801059da <alltraps>

80106413 <vector129>:
.globl vector129
vector129:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $129
80106415:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010641a:	e9 bb f5 ff ff       	jmp    801059da <alltraps>

8010641f <vector130>:
.globl vector130
vector130:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $130
80106421:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106426:	e9 af f5 ff ff       	jmp    801059da <alltraps>

8010642b <vector131>:
.globl vector131
vector131:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $131
8010642d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106432:	e9 a3 f5 ff ff       	jmp    801059da <alltraps>

80106437 <vector132>:
.globl vector132
vector132:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $132
80106439:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010643e:	e9 97 f5 ff ff       	jmp    801059da <alltraps>

80106443 <vector133>:
.globl vector133
vector133:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $133
80106445:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010644a:	e9 8b f5 ff ff       	jmp    801059da <alltraps>

8010644f <vector134>:
.globl vector134
vector134:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $134
80106451:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106456:	e9 7f f5 ff ff       	jmp    801059da <alltraps>

8010645b <vector135>:
.globl vector135
vector135:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $135
8010645d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106462:	e9 73 f5 ff ff       	jmp    801059da <alltraps>

80106467 <vector136>:
.globl vector136
vector136:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $136
80106469:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010646e:	e9 67 f5 ff ff       	jmp    801059da <alltraps>

80106473 <vector137>:
.globl vector137
vector137:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $137
80106475:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010647a:	e9 5b f5 ff ff       	jmp    801059da <alltraps>

8010647f <vector138>:
.globl vector138
vector138:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $138
80106481:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106486:	e9 4f f5 ff ff       	jmp    801059da <alltraps>

8010648b <vector139>:
.globl vector139
vector139:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $139
8010648d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106492:	e9 43 f5 ff ff       	jmp    801059da <alltraps>

80106497 <vector140>:
.globl vector140
vector140:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $140
80106499:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010649e:	e9 37 f5 ff ff       	jmp    801059da <alltraps>

801064a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $141
801064a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064aa:	e9 2b f5 ff ff       	jmp    801059da <alltraps>

801064af <vector142>:
.globl vector142
vector142:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $142
801064b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064b6:	e9 1f f5 ff ff       	jmp    801059da <alltraps>

801064bb <vector143>:
.globl vector143
vector143:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $143
801064bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801064c2:	e9 13 f5 ff ff       	jmp    801059da <alltraps>

801064c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $144
801064c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801064ce:	e9 07 f5 ff ff       	jmp    801059da <alltraps>

801064d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $145
801064d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801064da:	e9 fb f4 ff ff       	jmp    801059da <alltraps>

801064df <vector146>:
.globl vector146
vector146:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $146
801064e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801064e6:	e9 ef f4 ff ff       	jmp    801059da <alltraps>

801064eb <vector147>:
.globl vector147
vector147:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $147
801064ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801064f2:	e9 e3 f4 ff ff       	jmp    801059da <alltraps>

801064f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $148
801064f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801064fe:	e9 d7 f4 ff ff       	jmp    801059da <alltraps>

80106503 <vector149>:
.globl vector149
vector149:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $149
80106505:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010650a:	e9 cb f4 ff ff       	jmp    801059da <alltraps>

8010650f <vector150>:
.globl vector150
vector150:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $150
80106511:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106516:	e9 bf f4 ff ff       	jmp    801059da <alltraps>

8010651b <vector151>:
.globl vector151
vector151:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $151
8010651d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106522:	e9 b3 f4 ff ff       	jmp    801059da <alltraps>

80106527 <vector152>:
.globl vector152
vector152:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $152
80106529:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010652e:	e9 a7 f4 ff ff       	jmp    801059da <alltraps>

80106533 <vector153>:
.globl vector153
vector153:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $153
80106535:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010653a:	e9 9b f4 ff ff       	jmp    801059da <alltraps>

8010653f <vector154>:
.globl vector154
vector154:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $154
80106541:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106546:	e9 8f f4 ff ff       	jmp    801059da <alltraps>

8010654b <vector155>:
.globl vector155
vector155:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $155
8010654d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106552:	e9 83 f4 ff ff       	jmp    801059da <alltraps>

80106557 <vector156>:
.globl vector156
vector156:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $156
80106559:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010655e:	e9 77 f4 ff ff       	jmp    801059da <alltraps>

80106563 <vector157>:
.globl vector157
vector157:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $157
80106565:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010656a:	e9 6b f4 ff ff       	jmp    801059da <alltraps>

8010656f <vector158>:
.globl vector158
vector158:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $158
80106571:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106576:	e9 5f f4 ff ff       	jmp    801059da <alltraps>

8010657b <vector159>:
.globl vector159
vector159:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $159
8010657d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106582:	e9 53 f4 ff ff       	jmp    801059da <alltraps>

80106587 <vector160>:
.globl vector160
vector160:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $160
80106589:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010658e:	e9 47 f4 ff ff       	jmp    801059da <alltraps>

80106593 <vector161>:
.globl vector161
vector161:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $161
80106595:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010659a:	e9 3b f4 ff ff       	jmp    801059da <alltraps>

8010659f <vector162>:
.globl vector162
vector162:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $162
801065a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065a6:	e9 2f f4 ff ff       	jmp    801059da <alltraps>

801065ab <vector163>:
.globl vector163
vector163:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $163
801065ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065b2:	e9 23 f4 ff ff       	jmp    801059da <alltraps>

801065b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $164
801065b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065be:	e9 17 f4 ff ff       	jmp    801059da <alltraps>

801065c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $165
801065c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801065ca:	e9 0b f4 ff ff       	jmp    801059da <alltraps>

801065cf <vector166>:
.globl vector166
vector166:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $166
801065d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801065d6:	e9 ff f3 ff ff       	jmp    801059da <alltraps>

801065db <vector167>:
.globl vector167
vector167:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $167
801065dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801065e2:	e9 f3 f3 ff ff       	jmp    801059da <alltraps>

801065e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $168
801065e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801065ee:	e9 e7 f3 ff ff       	jmp    801059da <alltraps>

801065f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $169
801065f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801065fa:	e9 db f3 ff ff       	jmp    801059da <alltraps>

801065ff <vector170>:
.globl vector170
vector170:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $170
80106601:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106606:	e9 cf f3 ff ff       	jmp    801059da <alltraps>

8010660b <vector171>:
.globl vector171
vector171:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $171
8010660d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106612:	e9 c3 f3 ff ff       	jmp    801059da <alltraps>

80106617 <vector172>:
.globl vector172
vector172:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $172
80106619:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010661e:	e9 b7 f3 ff ff       	jmp    801059da <alltraps>

80106623 <vector173>:
.globl vector173
vector173:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $173
80106625:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010662a:	e9 ab f3 ff ff       	jmp    801059da <alltraps>

8010662f <vector174>:
.globl vector174
vector174:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $174
80106631:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106636:	e9 9f f3 ff ff       	jmp    801059da <alltraps>

8010663b <vector175>:
.globl vector175
vector175:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $175
8010663d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106642:	e9 93 f3 ff ff       	jmp    801059da <alltraps>

80106647 <vector176>:
.globl vector176
vector176:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $176
80106649:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010664e:	e9 87 f3 ff ff       	jmp    801059da <alltraps>

80106653 <vector177>:
.globl vector177
vector177:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $177
80106655:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010665a:	e9 7b f3 ff ff       	jmp    801059da <alltraps>

8010665f <vector178>:
.globl vector178
vector178:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $178
80106661:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106666:	e9 6f f3 ff ff       	jmp    801059da <alltraps>

8010666b <vector179>:
.globl vector179
vector179:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $179
8010666d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106672:	e9 63 f3 ff ff       	jmp    801059da <alltraps>

80106677 <vector180>:
.globl vector180
vector180:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $180
80106679:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010667e:	e9 57 f3 ff ff       	jmp    801059da <alltraps>

80106683 <vector181>:
.globl vector181
vector181:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $181
80106685:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010668a:	e9 4b f3 ff ff       	jmp    801059da <alltraps>

8010668f <vector182>:
.globl vector182
vector182:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $182
80106691:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106696:	e9 3f f3 ff ff       	jmp    801059da <alltraps>

8010669b <vector183>:
.globl vector183
vector183:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $183
8010669d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066a2:	e9 33 f3 ff ff       	jmp    801059da <alltraps>

801066a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $184
801066a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066ae:	e9 27 f3 ff ff       	jmp    801059da <alltraps>

801066b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $185
801066b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066ba:	e9 1b f3 ff ff       	jmp    801059da <alltraps>

801066bf <vector186>:
.globl vector186
vector186:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $186
801066c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801066c6:	e9 0f f3 ff ff       	jmp    801059da <alltraps>

801066cb <vector187>:
.globl vector187
vector187:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $187
801066cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801066d2:	e9 03 f3 ff ff       	jmp    801059da <alltraps>

801066d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801066d7:	6a 00                	push   $0x0
  pushl $188
801066d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801066de:	e9 f7 f2 ff ff       	jmp    801059da <alltraps>

801066e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801066e3:	6a 00                	push   $0x0
  pushl $189
801066e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801066ea:	e9 eb f2 ff ff       	jmp    801059da <alltraps>

801066ef <vector190>:
.globl vector190
vector190:
  pushl $0
801066ef:	6a 00                	push   $0x0
  pushl $190
801066f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801066f6:	e9 df f2 ff ff       	jmp    801059da <alltraps>

801066fb <vector191>:
.globl vector191
vector191:
  pushl $0
801066fb:	6a 00                	push   $0x0
  pushl $191
801066fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106702:	e9 d3 f2 ff ff       	jmp    801059da <alltraps>

80106707 <vector192>:
.globl vector192
vector192:
  pushl $0
80106707:	6a 00                	push   $0x0
  pushl $192
80106709:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010670e:	e9 c7 f2 ff ff       	jmp    801059da <alltraps>

80106713 <vector193>:
.globl vector193
vector193:
  pushl $0
80106713:	6a 00                	push   $0x0
  pushl $193
80106715:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010671a:	e9 bb f2 ff ff       	jmp    801059da <alltraps>

8010671f <vector194>:
.globl vector194
vector194:
  pushl $0
8010671f:	6a 00                	push   $0x0
  pushl $194
80106721:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106726:	e9 af f2 ff ff       	jmp    801059da <alltraps>

8010672b <vector195>:
.globl vector195
vector195:
  pushl $0
8010672b:	6a 00                	push   $0x0
  pushl $195
8010672d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106732:	e9 a3 f2 ff ff       	jmp    801059da <alltraps>

80106737 <vector196>:
.globl vector196
vector196:
  pushl $0
80106737:	6a 00                	push   $0x0
  pushl $196
80106739:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010673e:	e9 97 f2 ff ff       	jmp    801059da <alltraps>

80106743 <vector197>:
.globl vector197
vector197:
  pushl $0
80106743:	6a 00                	push   $0x0
  pushl $197
80106745:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010674a:	e9 8b f2 ff ff       	jmp    801059da <alltraps>

8010674f <vector198>:
.globl vector198
vector198:
  pushl $0
8010674f:	6a 00                	push   $0x0
  pushl $198
80106751:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106756:	e9 7f f2 ff ff       	jmp    801059da <alltraps>

8010675b <vector199>:
.globl vector199
vector199:
  pushl $0
8010675b:	6a 00                	push   $0x0
  pushl $199
8010675d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106762:	e9 73 f2 ff ff       	jmp    801059da <alltraps>

80106767 <vector200>:
.globl vector200
vector200:
  pushl $0
80106767:	6a 00                	push   $0x0
  pushl $200
80106769:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010676e:	e9 67 f2 ff ff       	jmp    801059da <alltraps>

80106773 <vector201>:
.globl vector201
vector201:
  pushl $0
80106773:	6a 00                	push   $0x0
  pushl $201
80106775:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010677a:	e9 5b f2 ff ff       	jmp    801059da <alltraps>

8010677f <vector202>:
.globl vector202
vector202:
  pushl $0
8010677f:	6a 00                	push   $0x0
  pushl $202
80106781:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106786:	e9 4f f2 ff ff       	jmp    801059da <alltraps>

8010678b <vector203>:
.globl vector203
vector203:
  pushl $0
8010678b:	6a 00                	push   $0x0
  pushl $203
8010678d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106792:	e9 43 f2 ff ff       	jmp    801059da <alltraps>

80106797 <vector204>:
.globl vector204
vector204:
  pushl $0
80106797:	6a 00                	push   $0x0
  pushl $204
80106799:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010679e:	e9 37 f2 ff ff       	jmp    801059da <alltraps>

801067a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067a3:	6a 00                	push   $0x0
  pushl $205
801067a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067aa:	e9 2b f2 ff ff       	jmp    801059da <alltraps>

801067af <vector206>:
.globl vector206
vector206:
  pushl $0
801067af:	6a 00                	push   $0x0
  pushl $206
801067b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067b6:	e9 1f f2 ff ff       	jmp    801059da <alltraps>

801067bb <vector207>:
.globl vector207
vector207:
  pushl $0
801067bb:	6a 00                	push   $0x0
  pushl $207
801067bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801067c2:	e9 13 f2 ff ff       	jmp    801059da <alltraps>

801067c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801067c7:	6a 00                	push   $0x0
  pushl $208
801067c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801067ce:	e9 07 f2 ff ff       	jmp    801059da <alltraps>

801067d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801067d3:	6a 00                	push   $0x0
  pushl $209
801067d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801067da:	e9 fb f1 ff ff       	jmp    801059da <alltraps>

801067df <vector210>:
.globl vector210
vector210:
  pushl $0
801067df:	6a 00                	push   $0x0
  pushl $210
801067e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801067e6:	e9 ef f1 ff ff       	jmp    801059da <alltraps>

801067eb <vector211>:
.globl vector211
vector211:
  pushl $0
801067eb:	6a 00                	push   $0x0
  pushl $211
801067ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801067f2:	e9 e3 f1 ff ff       	jmp    801059da <alltraps>

801067f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801067f7:	6a 00                	push   $0x0
  pushl $212
801067f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801067fe:	e9 d7 f1 ff ff       	jmp    801059da <alltraps>

80106803 <vector213>:
.globl vector213
vector213:
  pushl $0
80106803:	6a 00                	push   $0x0
  pushl $213
80106805:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010680a:	e9 cb f1 ff ff       	jmp    801059da <alltraps>

8010680f <vector214>:
.globl vector214
vector214:
  pushl $0
8010680f:	6a 00                	push   $0x0
  pushl $214
80106811:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106816:	e9 bf f1 ff ff       	jmp    801059da <alltraps>

8010681b <vector215>:
.globl vector215
vector215:
  pushl $0
8010681b:	6a 00                	push   $0x0
  pushl $215
8010681d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106822:	e9 b3 f1 ff ff       	jmp    801059da <alltraps>

80106827 <vector216>:
.globl vector216
vector216:
  pushl $0
80106827:	6a 00                	push   $0x0
  pushl $216
80106829:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010682e:	e9 a7 f1 ff ff       	jmp    801059da <alltraps>

80106833 <vector217>:
.globl vector217
vector217:
  pushl $0
80106833:	6a 00                	push   $0x0
  pushl $217
80106835:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010683a:	e9 9b f1 ff ff       	jmp    801059da <alltraps>

8010683f <vector218>:
.globl vector218
vector218:
  pushl $0
8010683f:	6a 00                	push   $0x0
  pushl $218
80106841:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106846:	e9 8f f1 ff ff       	jmp    801059da <alltraps>

8010684b <vector219>:
.globl vector219
vector219:
  pushl $0
8010684b:	6a 00                	push   $0x0
  pushl $219
8010684d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106852:	e9 83 f1 ff ff       	jmp    801059da <alltraps>

80106857 <vector220>:
.globl vector220
vector220:
  pushl $0
80106857:	6a 00                	push   $0x0
  pushl $220
80106859:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010685e:	e9 77 f1 ff ff       	jmp    801059da <alltraps>

80106863 <vector221>:
.globl vector221
vector221:
  pushl $0
80106863:	6a 00                	push   $0x0
  pushl $221
80106865:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010686a:	e9 6b f1 ff ff       	jmp    801059da <alltraps>

8010686f <vector222>:
.globl vector222
vector222:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $222
80106871:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106876:	e9 5f f1 ff ff       	jmp    801059da <alltraps>

8010687b <vector223>:
.globl vector223
vector223:
  pushl $0
8010687b:	6a 00                	push   $0x0
  pushl $223
8010687d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106882:	e9 53 f1 ff ff       	jmp    801059da <alltraps>

80106887 <vector224>:
.globl vector224
vector224:
  pushl $0
80106887:	6a 00                	push   $0x0
  pushl $224
80106889:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010688e:	e9 47 f1 ff ff       	jmp    801059da <alltraps>

80106893 <vector225>:
.globl vector225
vector225:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $225
80106895:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010689a:	e9 3b f1 ff ff       	jmp    801059da <alltraps>

8010689f <vector226>:
.globl vector226
vector226:
  pushl $0
8010689f:	6a 00                	push   $0x0
  pushl $226
801068a1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068a6:	e9 2f f1 ff ff       	jmp    801059da <alltraps>

801068ab <vector227>:
.globl vector227
vector227:
  pushl $0
801068ab:	6a 00                	push   $0x0
  pushl $227
801068ad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068b2:	e9 23 f1 ff ff       	jmp    801059da <alltraps>

801068b7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $228
801068b9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068be:	e9 17 f1 ff ff       	jmp    801059da <alltraps>

801068c3 <vector229>:
.globl vector229
vector229:
  pushl $0
801068c3:	6a 00                	push   $0x0
  pushl $229
801068c5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801068ca:	e9 0b f1 ff ff       	jmp    801059da <alltraps>

801068cf <vector230>:
.globl vector230
vector230:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $230
801068d1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801068d6:	e9 ff f0 ff ff       	jmp    801059da <alltraps>

801068db <vector231>:
.globl vector231
vector231:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $231
801068dd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801068e2:	e9 f3 f0 ff ff       	jmp    801059da <alltraps>

801068e7 <vector232>:
.globl vector232
vector232:
  pushl $0
801068e7:	6a 00                	push   $0x0
  pushl $232
801068e9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801068ee:	e9 e7 f0 ff ff       	jmp    801059da <alltraps>

801068f3 <vector233>:
.globl vector233
vector233:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $233
801068f5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801068fa:	e9 db f0 ff ff       	jmp    801059da <alltraps>

801068ff <vector234>:
.globl vector234
vector234:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $234
80106901:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106906:	e9 cf f0 ff ff       	jmp    801059da <alltraps>

8010690b <vector235>:
.globl vector235
vector235:
  pushl $0
8010690b:	6a 00                	push   $0x0
  pushl $235
8010690d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106912:	e9 c3 f0 ff ff       	jmp    801059da <alltraps>

80106917 <vector236>:
.globl vector236
vector236:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $236
80106919:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010691e:	e9 b7 f0 ff ff       	jmp    801059da <alltraps>

80106923 <vector237>:
.globl vector237
vector237:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $237
80106925:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010692a:	e9 ab f0 ff ff       	jmp    801059da <alltraps>

8010692f <vector238>:
.globl vector238
vector238:
  pushl $0
8010692f:	6a 00                	push   $0x0
  pushl $238
80106931:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106936:	e9 9f f0 ff ff       	jmp    801059da <alltraps>

8010693b <vector239>:
.globl vector239
vector239:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $239
8010693d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106942:	e9 93 f0 ff ff       	jmp    801059da <alltraps>

80106947 <vector240>:
.globl vector240
vector240:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $240
80106949:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010694e:	e9 87 f0 ff ff       	jmp    801059da <alltraps>

80106953 <vector241>:
.globl vector241
vector241:
  pushl $0
80106953:	6a 00                	push   $0x0
  pushl $241
80106955:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010695a:	e9 7b f0 ff ff       	jmp    801059da <alltraps>

8010695f <vector242>:
.globl vector242
vector242:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $242
80106961:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106966:	e9 6f f0 ff ff       	jmp    801059da <alltraps>

8010696b <vector243>:
.globl vector243
vector243:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $243
8010696d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106972:	e9 63 f0 ff ff       	jmp    801059da <alltraps>

80106977 <vector244>:
.globl vector244
vector244:
  pushl $0
80106977:	6a 00                	push   $0x0
  pushl $244
80106979:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010697e:	e9 57 f0 ff ff       	jmp    801059da <alltraps>

80106983 <vector245>:
.globl vector245
vector245:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $245
80106985:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010698a:	e9 4b f0 ff ff       	jmp    801059da <alltraps>

8010698f <vector246>:
.globl vector246
vector246:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $246
80106991:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106996:	e9 3f f0 ff ff       	jmp    801059da <alltraps>

8010699b <vector247>:
.globl vector247
vector247:
  pushl $0
8010699b:	6a 00                	push   $0x0
  pushl $247
8010699d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069a2:	e9 33 f0 ff ff       	jmp    801059da <alltraps>

801069a7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $248
801069a9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069ae:	e9 27 f0 ff ff       	jmp    801059da <alltraps>

801069b3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $249
801069b5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069ba:	e9 1b f0 ff ff       	jmp    801059da <alltraps>

801069bf <vector250>:
.globl vector250
vector250:
  pushl $0
801069bf:	6a 00                	push   $0x0
  pushl $250
801069c1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801069c6:	e9 0f f0 ff ff       	jmp    801059da <alltraps>

801069cb <vector251>:
.globl vector251
vector251:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $251
801069cd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801069d2:	e9 03 f0 ff ff       	jmp    801059da <alltraps>

801069d7 <vector252>:
.globl vector252
vector252:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $252
801069d9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801069de:	e9 f7 ef ff ff       	jmp    801059da <alltraps>

801069e3 <vector253>:
.globl vector253
vector253:
  pushl $0
801069e3:	6a 00                	push   $0x0
  pushl $253
801069e5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801069ea:	e9 eb ef ff ff       	jmp    801059da <alltraps>

801069ef <vector254>:
.globl vector254
vector254:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $254
801069f1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801069f6:	e9 df ef ff ff       	jmp    801059da <alltraps>

801069fb <vector255>:
.globl vector255
vector255:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $255
801069fd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a02:	e9 d3 ef ff ff       	jmp    801059da <alltraps>
80106a07:	66 90                	xchg   %ax,%ax
80106a09:	66 90                	xchg   %ax,%ax
80106a0b:	66 90                	xchg   %ax,%ax
80106a0d:	66 90                	xchg   %ax,%ax
80106a0f:	90                   	nop

80106a10 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	57                   	push   %edi
80106a14:	56                   	push   %esi
80106a15:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a16:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106a1c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a22:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106a25:	39 d3                	cmp    %edx,%ebx
80106a27:	73 56                	jae    80106a7f <deallocuvm.part.0+0x6f>
80106a29:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80106a2c:	89 c6                	mov    %eax,%esi
80106a2e:	89 d7                	mov    %edx,%edi
80106a30:	eb 12                	jmp    80106a44 <deallocuvm.part.0+0x34>
80106a32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106a38:	83 c2 01             	add    $0x1,%edx
80106a3b:	89 d3                	mov    %edx,%ebx
80106a3d:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a40:	39 fb                	cmp    %edi,%ebx
80106a42:	73 38                	jae    80106a7c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
80106a44:	89 da                	mov    %ebx,%edx
80106a46:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106a49:	8b 04 96             	mov    (%esi,%edx,4),%eax
80106a4c:	a8 01                	test   $0x1,%al
80106a4e:	74 e8                	je     80106a38 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
80106a50:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a52:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a57:	c1 e9 0a             	shr    $0xa,%ecx
80106a5a:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
80106a60:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
80106a67:	85 c0                	test   %eax,%eax
80106a69:	74 cd                	je     80106a38 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
80106a6b:	8b 10                	mov    (%eax),%edx
80106a6d:	f6 c2 01             	test   $0x1,%dl
80106a70:	75 1e                	jne    80106a90 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106a72:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a78:	39 fb                	cmp    %edi,%ebx
80106a7a:	72 c8                	jb     80106a44 <deallocuvm.part.0+0x34>
80106a7c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a82:	89 c8                	mov    %ecx,%eax
80106a84:	5b                   	pop    %ebx
80106a85:	5e                   	pop    %esi
80106a86:	5f                   	pop    %edi
80106a87:	5d                   	pop    %ebp
80106a88:	c3                   	ret
80106a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106a90:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a96:	74 26                	je     80106abe <deallocuvm.part.0+0xae>
      kfree(v);
80106a98:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a9b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106aa1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106aa4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106aaa:	52                   	push   %edx
80106aab:	e8 30 ba ff ff       	call   801024e0 <kfree>
      *pte = 0;
80106ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106ab3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106ab6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106abc:	eb 82                	jmp    80106a40 <deallocuvm.part.0+0x30>
        panic("kfree");
80106abe:	83 ec 0c             	sub    $0xc,%esp
80106ac1:	68 8c 75 10 80       	push   $0x8010758c
80106ac6:	e8 b5 98 ff ff       	call   80100380 <panic>
80106acb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106ad0 <mappages>:
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106ad6:	89 d3                	mov    %edx,%ebx
80106ad8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ade:	83 ec 1c             	sub    $0x1c,%esp
80106ae1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ae4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ae8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106aed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106af0:	8b 45 08             	mov    0x8(%ebp),%eax
80106af3:	29 d8                	sub    %ebx,%eax
80106af5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106af8:	eb 3f                	jmp    80106b39 <mappages+0x69>
80106afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106b00:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106b02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106b07:	c1 ea 0a             	shr    $0xa,%edx
80106b0a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106b10:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b17:	85 c0                	test   %eax,%eax
80106b19:	74 75                	je     80106b90 <mappages+0xc0>
    if(*pte & PTE_P)
80106b1b:	f6 00 01             	testb  $0x1,(%eax)
80106b1e:	0f 85 86 00 00 00    	jne    80106baa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106b24:	0b 75 0c             	or     0xc(%ebp),%esi
80106b27:	83 ce 01             	or     $0x1,%esi
80106b2a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b2c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b2f:	39 c3                	cmp    %eax,%ebx
80106b31:	74 6d                	je     80106ba0 <mappages+0xd0>
    a += PGSIZE;
80106b33:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106b3c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106b3f:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106b42:	89 d8                	mov    %ebx,%eax
80106b44:	c1 e8 16             	shr    $0x16,%eax
80106b47:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106b4a:	8b 07                	mov    (%edi),%eax
80106b4c:	a8 01                	test   $0x1,%al
80106b4e:	75 b0                	jne    80106b00 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106b50:	e8 ab bb ff ff       	call   80102700 <kalloc>
80106b55:	85 c0                	test   %eax,%eax
80106b57:	74 37                	je     80106b90 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106b59:	83 ec 04             	sub    $0x4,%esp
80106b5c:	68 00 10 00 00       	push   $0x1000
80106b61:	6a 00                	push   $0x0
80106b63:	50                   	push   %eax
80106b64:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106b67:	e8 24 dc ff ff       	call   80104790 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b6c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106b6f:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b72:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b78:	83 c8 07             	or     $0x7,%eax
80106b7b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b7d:	89 d8                	mov    %ebx,%eax
80106b7f:	c1 e8 0a             	shr    $0xa,%eax
80106b82:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b87:	01 d0                	add    %edx,%eax
80106b89:	eb 90                	jmp    80106b1b <mappages+0x4b>
80106b8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b98:	5b                   	pop    %ebx
80106b99:	5e                   	pop    %esi
80106b9a:	5f                   	pop    %edi
80106b9b:	5d                   	pop    %ebp
80106b9c:	c3                   	ret
80106b9d:	8d 76 00             	lea    0x0(%esi),%esi
80106ba0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ba3:	31 c0                	xor    %eax,%eax
}
80106ba5:	5b                   	pop    %ebx
80106ba6:	5e                   	pop    %esi
80106ba7:	5f                   	pop    %edi
80106ba8:	5d                   	pop    %ebp
80106ba9:	c3                   	ret
      panic("remap");
80106baa:	83 ec 0c             	sub    $0xc,%esp
80106bad:	68 ce 77 10 80       	push   $0x801077ce
80106bb2:	e8 c9 97 ff ff       	call   80100380 <panic>
80106bb7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bbe:	00 
80106bbf:	90                   	nop

80106bc0 <seginit>:
{
80106bc0:	55                   	push   %ebp
80106bc1:	89 e5                	mov    %esp,%ebp
80106bc3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106bc6:	e8 65 ce ff ff       	call   80103a30 <cpuid>
  pd[0] = size-1;
80106bcb:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106bd0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106bd6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106bda:	c7 80 18 18 18 80 ff 	movl   $0xffff,-0x7fe7e7e8(%eax)
80106be1:	ff 00 00 
80106be4:	c7 80 1c 18 18 80 00 	movl   $0xcf9a00,-0x7fe7e7e4(%eax)
80106beb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bee:	c7 80 20 18 18 80 ff 	movl   $0xffff,-0x7fe7e7e0(%eax)
80106bf5:	ff 00 00 
80106bf8:	c7 80 24 18 18 80 00 	movl   $0xcf9200,-0x7fe7e7dc(%eax)
80106bff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c02:	c7 80 28 18 18 80 ff 	movl   $0xffff,-0x7fe7e7d8(%eax)
80106c09:	ff 00 00 
80106c0c:	c7 80 2c 18 18 80 00 	movl   $0xcffa00,-0x7fe7e7d4(%eax)
80106c13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c16:	c7 80 30 18 18 80 ff 	movl   $0xffff,-0x7fe7e7d0(%eax)
80106c1d:	ff 00 00 
80106c20:	c7 80 34 18 18 80 00 	movl   $0xcff200,-0x7fe7e7cc(%eax)
80106c27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c2a:	05 10 18 18 80       	add    $0x80181810,%eax
  pd[1] = (uint)p;
80106c2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c33:	c1 e8 10             	shr    $0x10,%eax
80106c36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c3d:	0f 01 10             	lgdtl  (%eax)
}
80106c40:	c9                   	leave
80106c41:	c3                   	ret
80106c42:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c49:	00 
80106c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c50:	a1 c4 44 18 80       	mov    0x801844c4,%eax
80106c55:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c5a:	0f 22 d8             	mov    %eax,%cr3
}
80106c5d:	c3                   	ret
80106c5e:	66 90                	xchg   %ax,%ax

80106c60 <switchuvm>:
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	53                   	push   %ebx
80106c66:	83 ec 1c             	sub    $0x1c,%esp
80106c69:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c6c:	85 f6                	test   %esi,%esi
80106c6e:	0f 84 cb 00 00 00    	je     80106d3f <switchuvm+0xdf>
  if(p->kstack == 0)
80106c74:	8b 46 08             	mov    0x8(%esi),%eax
80106c77:	85 c0                	test   %eax,%eax
80106c79:	0f 84 da 00 00 00    	je     80106d59 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c7f:	8b 46 04             	mov    0x4(%esi),%eax
80106c82:	85 c0                	test   %eax,%eax
80106c84:	0f 84 c2 00 00 00    	je     80106d4c <switchuvm+0xec>
  pushcli();
80106c8a:	e8 b1 d8 ff ff       	call   80104540 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c8f:	e8 3c cd ff ff       	call   801039d0 <mycpu>
80106c94:	89 c3                	mov    %eax,%ebx
80106c96:	e8 35 cd ff ff       	call   801039d0 <mycpu>
80106c9b:	89 c7                	mov    %eax,%edi
80106c9d:	e8 2e cd ff ff       	call   801039d0 <mycpu>
80106ca2:	83 c7 08             	add    $0x8,%edi
80106ca5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ca8:	e8 23 cd ff ff       	call   801039d0 <mycpu>
80106cad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106cb0:	ba 67 00 00 00       	mov    $0x67,%edx
80106cb5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106cbc:	83 c0 08             	add    $0x8,%eax
80106cbf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cc6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106ccb:	83 c1 08             	add    $0x8,%ecx
80106cce:	c1 e8 18             	shr    $0x18,%eax
80106cd1:	c1 e9 10             	shr    $0x10,%ecx
80106cd4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106cda:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106ce0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106ce5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106cf1:	e8 da cc ff ff       	call   801039d0 <mycpu>
80106cf6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106cfd:	e8 ce cc ff ff       	call   801039d0 <mycpu>
80106d02:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d06:	8b 5e 08             	mov    0x8(%esi),%ebx
80106d09:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d0f:	e8 bc cc ff ff       	call   801039d0 <mycpu>
80106d14:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d17:	e8 b4 cc ff ff       	call   801039d0 <mycpu>
80106d1c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d20:	b8 28 00 00 00       	mov    $0x28,%eax
80106d25:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d28:	8b 46 04             	mov    0x4(%esi),%eax
80106d2b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d30:	0f 22 d8             	mov    %eax,%cr3
}
80106d33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d36:	5b                   	pop    %ebx
80106d37:	5e                   	pop    %esi
80106d38:	5f                   	pop    %edi
80106d39:	5d                   	pop    %ebp
  popcli();
80106d3a:	e9 51 d8 ff ff       	jmp    80104590 <popcli>
    panic("switchuvm: no process");
80106d3f:	83 ec 0c             	sub    $0xc,%esp
80106d42:	68 d4 77 10 80       	push   $0x801077d4
80106d47:	e8 34 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106d4c:	83 ec 0c             	sub    $0xc,%esp
80106d4f:	68 ff 77 10 80       	push   $0x801077ff
80106d54:	e8 27 96 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106d59:	83 ec 0c             	sub    $0xc,%esp
80106d5c:	68 ea 77 10 80       	push   $0x801077ea
80106d61:	e8 1a 96 ff ff       	call   80100380 <panic>
80106d66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d6d:	00 
80106d6e:	66 90                	xchg   %ax,%ax

80106d70 <inituvm>:
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
80106d73:	57                   	push   %edi
80106d74:	56                   	push   %esi
80106d75:	53                   	push   %ebx
80106d76:	83 ec 1c             	sub    $0x1c,%esp
80106d79:	8b 45 08             	mov    0x8(%ebp),%eax
80106d7c:	8b 75 10             	mov    0x10(%ebp),%esi
80106d7f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106d82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d85:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106d8b:	77 49                	ja     80106dd6 <inituvm+0x66>
  mem = kalloc();
80106d8d:	e8 6e b9 ff ff       	call   80102700 <kalloc>
  memset(mem, 0, PGSIZE);
80106d92:	83 ec 04             	sub    $0x4,%esp
80106d95:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106d9a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d9c:	6a 00                	push   $0x0
80106d9e:	50                   	push   %eax
80106d9f:	e8 ec d9 ff ff       	call   80104790 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106da4:	58                   	pop    %eax
80106da5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dab:	5a                   	pop    %edx
80106dac:	6a 06                	push   $0x6
80106dae:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106db3:	31 d2                	xor    %edx,%edx
80106db5:	50                   	push   %eax
80106db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106db9:	e8 12 fd ff ff       	call   80106ad0 <mappages>
  memmove(mem, init, sz);
80106dbe:	83 c4 10             	add    $0x10,%esp
80106dc1:	89 75 10             	mov    %esi,0x10(%ebp)
80106dc4:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106dc7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dcd:	5b                   	pop    %ebx
80106dce:	5e                   	pop    %esi
80106dcf:	5f                   	pop    %edi
80106dd0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106dd1:	e9 4a da ff ff       	jmp    80104820 <memmove>
    panic("inituvm: more than a page");
80106dd6:	83 ec 0c             	sub    $0xc,%esp
80106dd9:	68 13 78 10 80       	push   $0x80107813
80106dde:	e8 9d 95 ff ff       	call   80100380 <panic>
80106de3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106dea:	00 
80106deb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106df0 <loaduvm>:
{
80106df0:	55                   	push   %ebp
80106df1:	89 e5                	mov    %esp,%ebp
80106df3:	57                   	push   %edi
80106df4:	56                   	push   %esi
80106df5:	53                   	push   %ebx
80106df6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106df9:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106dfc:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106dff:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106e05:	0f 85 a2 00 00 00    	jne    80106ead <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106e0b:	85 ff                	test   %edi,%edi
80106e0d:	74 7d                	je     80106e8c <loaduvm+0x9c>
80106e0f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106e13:	8b 55 08             	mov    0x8(%ebp),%edx
80106e16:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106e18:	89 c1                	mov    %eax,%ecx
80106e1a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106e1d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106e20:	f6 c1 01             	test   $0x1,%cl
80106e23:	75 13                	jne    80106e38 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106e25:	83 ec 0c             	sub    $0xc,%esp
80106e28:	68 2d 78 10 80       	push   $0x8010782d
80106e2d:	e8 4e 95 ff ff       	call   80100380 <panic>
80106e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e38:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e3b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106e41:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e46:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e4d:	85 c9                	test   %ecx,%ecx
80106e4f:	74 d4                	je     80106e25 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106e51:	89 fb                	mov    %edi,%ebx
80106e53:	b8 00 10 00 00       	mov    $0x1000,%eax
80106e58:	29 f3                	sub    %esi,%ebx
80106e5a:	39 c3                	cmp    %eax,%ebx
80106e5c:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e5f:	53                   	push   %ebx
80106e60:	8b 45 14             	mov    0x14(%ebp),%eax
80106e63:	01 f0                	add    %esi,%eax
80106e65:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106e66:	8b 01                	mov    (%ecx),%eax
80106e68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e6d:	05 00 00 00 80       	add    $0x80000000,%eax
80106e72:	50                   	push   %eax
80106e73:	ff 75 10             	push   0x10(%ebp)
80106e76:	e8 35 ac ff ff       	call   80101ab0 <readi>
80106e7b:	83 c4 10             	add    $0x10,%esp
80106e7e:	39 d8                	cmp    %ebx,%eax
80106e80:	75 1e                	jne    80106ea0 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106e82:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e88:	39 fe                	cmp    %edi,%esi
80106e8a:	72 84                	jb     80106e10 <loaduvm+0x20>
}
80106e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106e8f:	31 c0                	xor    %eax,%eax
}
80106e91:	5b                   	pop    %ebx
80106e92:	5e                   	pop    %esi
80106e93:	5f                   	pop    %edi
80106e94:	5d                   	pop    %ebp
80106e95:	c3                   	ret
80106e96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e9d:	00 
80106e9e:	66 90                	xchg   %ax,%ax
80106ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ea3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ea8:	5b                   	pop    %ebx
80106ea9:	5e                   	pop    %esi
80106eaa:	5f                   	pop    %edi
80106eab:	5d                   	pop    %ebp
80106eac:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106ead:	83 ec 0c             	sub    $0xc,%esp
80106eb0:	68 50 7a 10 80       	push   $0x80107a50
80106eb5:	e8 c6 94 ff ff       	call   80100380 <panic>
80106eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ec0 <allocuvm>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
80106ec9:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106ecc:	85 f6                	test   %esi,%esi
80106ece:	0f 88 98 00 00 00    	js     80106f6c <allocuvm+0xac>
80106ed4:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106ed6:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106ed9:	0f 82 a1 00 00 00    	jb     80106f80 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106edf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ee2:	05 ff 0f 00 00       	add    $0xfff,%eax
80106ee7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106eec:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106eee:	39 f0                	cmp    %esi,%eax
80106ef0:	0f 83 8d 00 00 00    	jae    80106f83 <allocuvm+0xc3>
80106ef6:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106ef9:	eb 44                	jmp    80106f3f <allocuvm+0x7f>
80106efb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106f00:	83 ec 04             	sub    $0x4,%esp
80106f03:	68 00 10 00 00       	push   $0x1000
80106f08:	6a 00                	push   $0x0
80106f0a:	50                   	push   %eax
80106f0b:	e8 80 d8 ff ff       	call   80104790 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f10:	58                   	pop    %eax
80106f11:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f17:	5a                   	pop    %edx
80106f18:	6a 06                	push   $0x6
80106f1a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f1f:	89 fa                	mov    %edi,%edx
80106f21:	50                   	push   %eax
80106f22:	8b 45 08             	mov    0x8(%ebp),%eax
80106f25:	e8 a6 fb ff ff       	call   80106ad0 <mappages>
80106f2a:	83 c4 10             	add    $0x10,%esp
80106f2d:	85 c0                	test   %eax,%eax
80106f2f:	78 5f                	js     80106f90 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106f31:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106f37:	39 f7                	cmp    %esi,%edi
80106f39:	0f 83 89 00 00 00    	jae    80106fc8 <allocuvm+0x108>
    mem = kalloc();
80106f3f:	e8 bc b7 ff ff       	call   80102700 <kalloc>
80106f44:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106f46:	85 c0                	test   %eax,%eax
80106f48:	75 b6                	jne    80106f00 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f4a:	83 ec 0c             	sub    $0xc,%esp
80106f4d:	68 4b 78 10 80       	push   $0x8010784b
80106f52:	e8 59 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f57:	83 c4 10             	add    $0x10,%esp
80106f5a:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f5d:	74 0d                	je     80106f6c <allocuvm+0xac>
80106f5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f62:	8b 45 08             	mov    0x8(%ebp),%eax
80106f65:	89 f2                	mov    %esi,%edx
80106f67:	e8 a4 fa ff ff       	call   80106a10 <deallocuvm.part.0>
    return 0;
80106f6c:	31 d2                	xor    %edx,%edx
}
80106f6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f71:	89 d0                	mov    %edx,%eax
80106f73:	5b                   	pop    %ebx
80106f74:	5e                   	pop    %esi
80106f75:	5f                   	pop    %edi
80106f76:	5d                   	pop    %ebp
80106f77:	c3                   	ret
80106f78:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f7f:	00 
    return oldsz;
80106f80:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f86:	89 d0                	mov    %edx,%eax
80106f88:	5b                   	pop    %ebx
80106f89:	5e                   	pop    %esi
80106f8a:	5f                   	pop    %edi
80106f8b:	5d                   	pop    %ebp
80106f8c:	c3                   	ret
80106f8d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f90:	83 ec 0c             	sub    $0xc,%esp
80106f93:	68 63 78 10 80       	push   $0x80107863
80106f98:	e8 13 97 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106f9d:	83 c4 10             	add    $0x10,%esp
80106fa0:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106fa3:	74 0d                	je     80106fb2 <allocuvm+0xf2>
80106fa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80106fab:	89 f2                	mov    %esi,%edx
80106fad:	e8 5e fa ff ff       	call   80106a10 <deallocuvm.part.0>
      kfree(mem);
80106fb2:	83 ec 0c             	sub    $0xc,%esp
80106fb5:	53                   	push   %ebx
80106fb6:	e8 25 b5 ff ff       	call   801024e0 <kfree>
      return 0;
80106fbb:	83 c4 10             	add    $0x10,%esp
    return 0;
80106fbe:	31 d2                	xor    %edx,%edx
80106fc0:	eb ac                	jmp    80106f6e <allocuvm+0xae>
80106fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fc8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106fcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fce:	5b                   	pop    %ebx
80106fcf:	5e                   	pop    %esi
80106fd0:	89 d0                	mov    %edx,%eax
80106fd2:	5f                   	pop    %edi
80106fd3:	5d                   	pop    %ebp
80106fd4:	c3                   	ret
80106fd5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fdc:	00 
80106fdd:	8d 76 00             	lea    0x0(%esi),%esi

80106fe0 <deallocuvm>:
{
80106fe0:	55                   	push   %ebp
80106fe1:	89 e5                	mov    %esp,%ebp
80106fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fe6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106fec:	39 d1                	cmp    %edx,%ecx
80106fee:	73 10                	jae    80107000 <deallocuvm+0x20>
}
80106ff0:	5d                   	pop    %ebp
80106ff1:	e9 1a fa ff ff       	jmp    80106a10 <deallocuvm.part.0>
80106ff6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ffd:	00 
80106ffe:	66 90                	xchg   %ax,%ax
80107000:	89 d0                	mov    %edx,%eax
80107002:	5d                   	pop    %ebp
80107003:	c3                   	ret
80107004:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010700b:	00 
8010700c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107010 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 0c             	sub    $0xc,%esp
80107019:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010701c:	85 f6                	test   %esi,%esi
8010701e:	74 59                	je     80107079 <freevm+0x69>
  if(newsz >= oldsz)
80107020:	31 c9                	xor    %ecx,%ecx
80107022:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107027:	89 f0                	mov    %esi,%eax
80107029:	89 f3                	mov    %esi,%ebx
8010702b:	e8 e0 f9 ff ff       	call   80106a10 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107030:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107036:	eb 0f                	jmp    80107047 <freevm+0x37>
80107038:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010703f:	00 
80107040:	83 c3 04             	add    $0x4,%ebx
80107043:	39 fb                	cmp    %edi,%ebx
80107045:	74 23                	je     8010706a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107047:	8b 03                	mov    (%ebx),%eax
80107049:	a8 01                	test   $0x1,%al
8010704b:	74 f3                	je     80107040 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010704d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107052:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107055:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107058:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010705d:	50                   	push   %eax
8010705e:	e8 7d b4 ff ff       	call   801024e0 <kfree>
80107063:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107066:	39 fb                	cmp    %edi,%ebx
80107068:	75 dd                	jne    80107047 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010706a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010706d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107070:	5b                   	pop    %ebx
80107071:	5e                   	pop    %esi
80107072:	5f                   	pop    %edi
80107073:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107074:	e9 67 b4 ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
80107079:	83 ec 0c             	sub    $0xc,%esp
8010707c:	68 7f 78 10 80       	push   $0x8010787f
80107081:	e8 fa 92 ff ff       	call   80100380 <panic>
80107086:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010708d:	00 
8010708e:	66 90                	xchg   %ax,%ax

80107090 <setupkvm>:
{
80107090:	55                   	push   %ebp
80107091:	89 e5                	mov    %esp,%ebp
80107093:	56                   	push   %esi
80107094:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107095:	e8 66 b6 ff ff       	call   80102700 <kalloc>
8010709a:	85 c0                	test   %eax,%eax
8010709c:	74 5e                	je     801070fc <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010709e:	83 ec 04             	sub    $0x4,%esp
801070a1:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070a3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070a8:	68 00 10 00 00       	push   $0x1000
801070ad:	6a 00                	push   $0x0
801070af:	50                   	push   %eax
801070b0:	e8 db d6 ff ff       	call   80104790 <memset>
801070b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801070b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801070bb:	83 ec 08             	sub    $0x8,%esp
801070be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801070c1:	8b 13                	mov    (%ebx),%edx
801070c3:	ff 73 0c             	push   0xc(%ebx)
801070c6:	50                   	push   %eax
801070c7:	29 c1                	sub    %eax,%ecx
801070c9:	89 f0                	mov    %esi,%eax
801070cb:	e8 00 fa ff ff       	call   80106ad0 <mappages>
801070d0:	83 c4 10             	add    $0x10,%esp
801070d3:	85 c0                	test   %eax,%eax
801070d5:	78 19                	js     801070f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070d7:	83 c3 10             	add    $0x10,%ebx
801070da:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801070e0:	75 d6                	jne    801070b8 <setupkvm+0x28>
}
801070e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801070e5:	89 f0                	mov    %esi,%eax
801070e7:	5b                   	pop    %ebx
801070e8:	5e                   	pop    %esi
801070e9:	5d                   	pop    %ebp
801070ea:	c3                   	ret
801070eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801070f0:	83 ec 0c             	sub    $0xc,%esp
801070f3:	56                   	push   %esi
801070f4:	e8 17 ff ff ff       	call   80107010 <freevm>
      return 0;
801070f9:	83 c4 10             	add    $0x10,%esp
}
801070fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
801070ff:	31 f6                	xor    %esi,%esi
}
80107101:	89 f0                	mov    %esi,%eax
80107103:	5b                   	pop    %ebx
80107104:	5e                   	pop    %esi
80107105:	5d                   	pop    %ebp
80107106:	c3                   	ret
80107107:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010710e:	00 
8010710f:	90                   	nop

80107110 <kvmalloc>:
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107116:	e8 75 ff ff ff       	call   80107090 <setupkvm>
8010711b:	a3 c4 44 18 80       	mov    %eax,0x801844c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107120:	05 00 00 00 80       	add    $0x80000000,%eax
80107125:	0f 22 d8             	mov    %eax,%cr3
}
80107128:	c9                   	leave
80107129:	c3                   	ret
8010712a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107130 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	83 ec 08             	sub    $0x8,%esp
80107136:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107139:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010713c:	89 c1                	mov    %eax,%ecx
8010713e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107141:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107144:	f6 c2 01             	test   $0x1,%dl
80107147:	75 17                	jne    80107160 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107149:	83 ec 0c             	sub    $0xc,%esp
8010714c:	68 90 78 10 80       	push   $0x80107890
80107151:	e8 2a 92 ff ff       	call   80100380 <panic>
80107156:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010715d:	00 
8010715e:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107160:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107163:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107169:	25 fc 0f 00 00       	and    $0xffc,%eax
8010716e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107175:	85 c0                	test   %eax,%eax
80107177:	74 d0                	je     80107149 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107179:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010717c:	c9                   	leave
8010717d:	c3                   	ret
8010717e:	66 90                	xchg   %ax,%ax

80107180 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107180:	55                   	push   %ebp
80107181:	89 e5                	mov    %esp,%ebp
80107183:	57                   	push   %edi
80107184:	56                   	push   %esi
80107185:	53                   	push   %ebx
80107186:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107189:	e8 02 ff ff ff       	call   80107090 <setupkvm>
8010718e:	85 c0                	test   %eax,%eax
80107190:	0f 84 f1 00 00 00    	je     80107287 <copyuvm+0x107>
80107196:	89 c7                	mov    %eax,%edi
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107198:	8b 45 0c             	mov    0xc(%ebp),%eax
8010719b:	85 c0                	test   %eax,%eax
8010719d:	0f 84 c7 00 00 00    	je     8010726a <copyuvm+0xea>
801071a3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801071a6:	8b 7d 08             	mov    0x8(%ebp),%edi
801071a9:	31 f6                	xor    %esi,%esi
801071ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801071b0:	89 f0                	mov    %esi,%eax
801071b2:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801071b5:	8b 04 87             	mov    (%edi,%eax,4),%eax
801071b8:	a8 01                	test   $0x1,%al
801071ba:	75 14                	jne    801071d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801071bc:	83 ec 0c             	sub    $0xc,%esp
801071bf:	68 9a 78 10 80       	push   $0x8010789a
801071c4:	e8 b7 91 ff ff       	call   80100380 <panic>
801071c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801071d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071d7:	c1 ea 0a             	shr    $0xa,%edx
801071da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801071e7:	85 c0                	test   %eax,%eax
801071e9:	74 d1                	je     801071bc <copyuvm+0x3c>
    if(!(*pte & PTE_P))
801071eb:	8b 18                	mov    (%eax),%ebx
801071ed:	f6 c3 01             	test   $0x1,%bl
801071f0:	0f 84 9d 00 00 00    	je     80107293 <copyuvm+0x113>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
801071f6:	89 d8                	mov    %ebx,%eax
    pa = PTE_ADDR(*pte);
801071f8:	89 da                	mov    %ebx,%edx
    flags = PTE_FLAGS(*pte);
801071fa:	89 d9                	mov    %ebx,%ecx
801071fc:	25 fd 0f 00 00       	and    $0xffd,%eax
    pa = PTE_ADDR(*pte);
80107201:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    flags = PTE_FLAGS(*pte);
80107207:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
8010720d:	80 cc 08             	or     $0x8,%ah
80107210:	f6 c3 02             	test   $0x2,%bl
80107213:	0f 44 c1             	cmove  %ecx,%eax
      flags &= ~PTE_W;  // Remove write permission
      flags |= PTE_COW; // Set COW flag
    }

    // Map the page in the new process
    if (mappages(d, (void*)i, PGSIZE, pa, flags) < 0)
80107216:	83 ec 08             	sub    $0x8,%esp
80107219:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010721e:	50                   	push   %eax
8010721f:	52                   	push   %edx
80107220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107223:	89 f2                	mov    %esi,%edx
80107225:	e8 a6 f8 ff ff       	call   80106ad0 <mappages>
8010722a:	83 c4 10             	add    $0x10,%esp
8010722d:	85 c0                	test   %eax,%eax
8010722f:	78 47                	js     80107278 <copyuvm+0xf8>
      goto bad;
    
    // Increment reference count for shared page
    acquire(&kmem.lock);
80107231:	83 ec 0c             	sub    $0xc,%esp
    kref[pa / PGSIZE]++;
80107234:	c1 eb 0c             	shr    $0xc,%ebx
  for(i = 0; i < sz; i += PGSIZE){
80107237:	81 c6 00 10 00 00    	add    $0x1000,%esi
    acquire(&kmem.lock);
8010723d:	68 40 96 14 80       	push   $0x80149640
80107242:	e8 49 d4 ff ff       	call   80104690 <acquire>
    kref[pa / PGSIZE]++;
80107247:	83 04 9d 40 16 11 80 	addl   $0x1,-0x7feee9c0(,%ebx,4)
8010724e:	01 
    release(&kmem.lock);
8010724f:	c7 04 24 40 96 14 80 	movl   $0x80149640,(%esp)
80107256:	e8 d5 d3 ff ff       	call   80104630 <release>
  for(i = 0; i < sz; i += PGSIZE){
8010725b:	83 c4 10             	add    $0x10,%esp
8010725e:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107261:	0f 82 49 ff ff ff    	jb     801071b0 <copyuvm+0x30>
80107267:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    return d;

bad:
  freevm(d);
  return 0;
  }
8010726a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010726d:	89 f8                	mov    %edi,%eax
8010726f:	5b                   	pop    %ebx
80107270:	5e                   	pop    %esi
80107271:	5f                   	pop    %edi
80107272:	5d                   	pop    %ebp
80107273:	c3                   	ret
80107274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  freevm(d);
80107278:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010727b:	83 ec 0c             	sub    $0xc,%esp
8010727e:	57                   	push   %edi
8010727f:	e8 8c fd ff ff       	call   80107010 <freevm>
  return 0;
80107284:	83 c4 10             	add    $0x10,%esp
  }
80107287:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
8010728a:	31 ff                	xor    %edi,%edi
  }
8010728c:	5b                   	pop    %ebx
8010728d:	89 f8                	mov    %edi,%eax
8010728f:	5e                   	pop    %esi
80107290:	5f                   	pop    %edi
80107291:	5d                   	pop    %ebp
80107292:	c3                   	ret
      panic("copyuvm: page not present");
80107293:	83 ec 0c             	sub    $0xc,%esp
80107296:	68 b4 78 10 80       	push   $0x801078b4
8010729b:	e8 e0 90 ff ff       	call   80100380 <panic>

801072a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801072a6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801072a9:	89 c1                	mov    %eax,%ecx
801072ab:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801072ae:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801072b1:	f6 c2 01             	test   $0x1,%dl
801072b4:	0f 84 f8 00 00 00    	je     801073b2 <uva2ka.cold>
  return &pgtab[PTX(va)];
801072ba:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072bd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072c3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801072c4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801072c9:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072d0:	89 d0                	mov    %edx,%eax
801072d2:	f7 d2                	not    %edx
801072d4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072d9:	05 00 00 00 80       	add    $0x80000000,%eax
801072de:	83 e2 05             	and    $0x5,%edx
801072e1:	ba 00 00 00 00       	mov    $0x0,%edx
801072e6:	0f 45 c2             	cmovne %edx,%eax
}
801072e9:	c3                   	ret
801072ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 0c             	sub    $0xc,%esp
801072f9:	8b 75 14             	mov    0x14(%ebp),%esi
801072fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ff:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107302:	85 f6                	test   %esi,%esi
80107304:	75 51                	jne    80107357 <copyout+0x67>
80107306:	e9 9d 00 00 00       	jmp    801073a8 <copyout+0xb8>
8010730b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107310:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107316:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010731c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107322:	74 74                	je     80107398 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
80107324:	89 fb                	mov    %edi,%ebx
80107326:	29 c3                	sub    %eax,%ebx
80107328:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010732e:	39 f3                	cmp    %esi,%ebx
80107330:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107333:	29 f8                	sub    %edi,%eax
80107335:	83 ec 04             	sub    $0x4,%esp
80107338:	01 c1                	add    %eax,%ecx
8010733a:	53                   	push   %ebx
8010733b:	52                   	push   %edx
8010733c:	89 55 10             	mov    %edx,0x10(%ebp)
8010733f:	51                   	push   %ecx
80107340:	e8 db d4 ff ff       	call   80104820 <memmove>
    len -= n;
    buf += n;
80107345:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107348:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010734e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107351:	01 da                	add    %ebx,%edx
  while(len > 0){
80107353:	29 de                	sub    %ebx,%esi
80107355:	74 51                	je     801073a8 <copyout+0xb8>
  if(*pde & PTE_P){
80107357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010735a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010735c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010735e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107361:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107367:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010736a:	f6 c1 01             	test   $0x1,%cl
8010736d:	0f 84 46 00 00 00    	je     801073b9 <copyout.cold>
  return &pgtab[PTX(va)];
80107373:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107375:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010737b:	c1 eb 0c             	shr    $0xc,%ebx
8010737e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107384:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010738b:	89 d9                	mov    %ebx,%ecx
8010738d:	f7 d1                	not    %ecx
8010738f:	83 e1 05             	and    $0x5,%ecx
80107392:	0f 84 78 ff ff ff    	je     80107310 <copyout+0x20>
  }
  return 0;
}
80107398:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010739b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073a0:	5b                   	pop    %ebx
801073a1:	5e                   	pop    %esi
801073a2:	5f                   	pop    %edi
801073a3:	5d                   	pop    %ebp
801073a4:	c3                   	ret
801073a5:	8d 76 00             	lea    0x0(%esi),%esi
801073a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801073ab:	31 c0                	xor    %eax,%eax
}
801073ad:	5b                   	pop    %ebx
801073ae:	5e                   	pop    %esi
801073af:	5f                   	pop    %edi
801073b0:	5d                   	pop    %ebp
801073b1:	c3                   	ret

801073b2 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801073b2:	a1 00 00 00 00       	mov    0x0,%eax
801073b7:	0f 0b                	ud2

801073b9 <copyout.cold>:
801073b9:	a1 00 00 00 00       	mov    0x0,%eax
801073be:	0f 0b                	ud2
