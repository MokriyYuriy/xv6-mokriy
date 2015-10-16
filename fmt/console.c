7800 // Console input and output.
7801 // Input is from the keyboard or serial port.
7802 // Output is written to the screen and serial port.
7803 
7804 #include "types.h"
7805 #include "defs.h"
7806 #include "param.h"
7807 #include "traps.h"
7808 #include "spinlock.h"
7809 #include "fs.h"
7810 #include "file.h"
7811 #include "memlayout.h"
7812 #include "mmu.h"
7813 #include "proc.h"
7814 #include "x86.h"
7815 
7816 static void consputc(int);
7817 
7818 static int panicked = 0;
7819 
7820 static struct {
7821   struct spinlock lock;
7822   int locking;
7823 } cons;
7824 
7825 static void
7826 printint(int xx, int base, int sign)
7827 {
7828   static char digits[] = "0123456789abcdef";
7829   char buf[16];
7830   int i;
7831   uint x;
7832 
7833   if(sign && (sign = xx < 0))
7834     x = -xx;
7835   else
7836     x = xx;
7837 
7838   i = 0;
7839   do{
7840     buf[i++] = digits[x % base];
7841   }while((x /= base) != 0);
7842 
7843   if(sign)
7844     buf[i++] = '-';
7845 
7846   while(--i >= 0)
7847     consputc(buf[i]);
7848 }
7849 
7850 // Print to the console. only understands %d, %x, %p, %s.
7851 void
7852 cprintf(char *fmt, ...)
7853 {
7854   int i, c, locking;
7855   uint *argp;
7856   char *s;
7857 
7858   locking = cons.locking;
7859   if(locking)
7860     acquire(&cons.lock);
7861 
7862   if (fmt == 0)
7863     panic("null fmt");
7864 
7865   argp = (uint*)(void*)(&fmt + 1);
7866   for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
7867     if(c != '%'){
7868       consputc(c);
7869       continue;
7870     }
7871     c = fmt[++i] & 0xff;
7872     if(c == 0)
7873       break;
7874     switch(c){
7875     case 'd':
7876       printint(*argp++, 10, 1);
7877       break;
7878     case 'x':
7879     case 'p':
7880       printint(*argp++, 16, 0);
7881       break;
7882     case 's':
7883       if((s = (char*)*argp++) == 0)
7884         s = "(null)";
7885       for(; *s; s++)
7886         consputc(*s);
7887       break;
7888     case '%':
7889       consputc('%');
7890       break;
7891     default:
7892       // Print unknown % sequence to draw attention.
7893       consputc('%');
7894       consputc(c);
7895       break;
7896     }
7897   }
7898 
7899 
7900   if(locking)
7901     release(&cons.lock);
7902 }
7903 
7904 void
7905 panic(char *s)
7906 {
7907   int i;
7908   uint pcs[10];
7909 
7910   cli();
7911   cons.locking = 0;
7912   cprintf("cpu%d: panic: ", cpu->id);
7913   cprintf(s);
7914   cprintf("\n");
7915   getcallerpcs(&s, pcs);
7916   for(i=0; i<10; i++)
7917     cprintf(" %p", pcs[i]);
7918   panicked = 1; // freeze other CPU
7919   for(;;)
7920     ;
7921 }
7922 
7923 
7924 
7925 
7926 
7927 
7928 
7929 
7930 
7931 
7932 
7933 
7934 
7935 
7936 
7937 
7938 
7939 
7940 
7941 
7942 
7943 
7944 
7945 
7946 
7947 
7948 
7949 
7950 #define BACKSPACE 0x100
7951 #define CRTPORT 0x3d4
7952 static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory
7953 
7954 static void
7955 cgaputc(int c)
7956 {
7957   int pos;
7958 
7959   // Cursor position: col + 80*row.
7960   outb(CRTPORT, 14);
7961   pos = inb(CRTPORT+1) << 8;
7962   outb(CRTPORT, 15);
7963   pos |= inb(CRTPORT+1);
7964 
7965   if(c == '\n')
7966     pos += 80 - pos%80;
7967   else if(c == BACKSPACE){
7968     if(pos > 0) --pos;
7969   } else
7970     crt[pos++] = (c&0xff) | 0x0700;  // black on white
7971 
7972   if((pos/80) >= 24){  // Scroll up.
7973     memmove(crt, crt+80, sizeof(crt[0])*23*80);
7974     pos -= 80;
7975     memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
7976   }
7977 
7978   outb(CRTPORT, 14);
7979   outb(CRTPORT+1, pos>>8);
7980   outb(CRTPORT, 15);
7981   outb(CRTPORT+1, pos);
7982   crt[pos] = ' ' | 0x0700;
7983 }
7984 
7985 void
7986 consputc(int c)
7987 {
7988   if(panicked){
7989     cli();
7990     for(;;)
7991       ;
7992   }
7993 
7994   if(c == BACKSPACE){
7995     uartputc('\b'); uartputc(' '); uartputc('\b');
7996   } else
7997     uartputc(c);
7998   cgaputc(c);
7999 }
8000 #define INPUT_BUF 128
8001 struct {
8002   struct spinlock lock;
8003   char buf[INPUT_BUF];
8004   uint r;  // Read index
8005   uint w;  // Write index
8006   uint e;  // Edit index
8007 } input;
8008 
8009 #define C(x)  ((x)-'@')  // Control-x
8010 
8011 void
8012 consoleintr(int (*getc)(void))
8013 {
8014   int c;
8015 
8016   acquire(&input.lock);
8017   while((c = getc()) >= 0){
8018     switch(c){
8019     case C('P'):  // Process listing.
8020       procdump();
8021       break;
8022     case C('U'):  // Kill line.
8023       while(input.e != input.w &&
8024             input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8025         input.e--;
8026         consputc(BACKSPACE);
8027       }
8028       break;
8029     case C('H'): case '\x7f':  // Backspace
8030       if(input.e != input.w){
8031         input.e--;
8032         consputc(BACKSPACE);
8033       }
8034       break;
8035     default:
8036       if(c != 0 && input.e-input.r < INPUT_BUF){
8037         c = (c == '\r') ? '\n' : c;
8038         input.buf[input.e++ % INPUT_BUF] = c;
8039         consputc(c);
8040         if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8041           input.w = input.e;
8042           wakeup(&input.r);
8043         }
8044       }
8045       break;
8046     }
8047   }
8048   release(&input.lock);
8049 }
8050 int
8051 consoleread(struct inode *ip, char *dst, int n)
8052 {
8053   uint target;
8054   int c;
8055 
8056   iunlock(ip);
8057   target = n;
8058   acquire(&input.lock);
8059   while(n > 0){
8060     while(input.r == input.w){
8061       if(proc->killed){
8062         release(&input.lock);
8063         ilock(ip);
8064         return -1;
8065       }
8066       sleep(&input.r, &input.lock);
8067     }
8068     c = input.buf[input.r++ % INPUT_BUF];
8069     if(c == C('D')){  // EOF
8070       if(n < target){
8071         // Save ^D for next time, to make sure
8072         // caller gets a 0-byte result.
8073         input.r--;
8074       }
8075       break;
8076     }
8077     *dst++ = c;
8078     --n;
8079     if(c == '\n')
8080       break;
8081   }
8082   release(&input.lock);
8083   ilock(ip);
8084 
8085   return target - n;
8086 }
8087 
8088 
8089 
8090 
8091 
8092 
8093 
8094 
8095 
8096 
8097 
8098 
8099 
8100 int
8101 consolewrite(struct inode *ip, char *buf, int n)
8102 {
8103   int i;
8104 
8105   iunlock(ip);
8106   acquire(&cons.lock);
8107   for(i = 0; i < n; i++)
8108     consputc(buf[i] & 0xff);
8109   release(&cons.lock);
8110   ilock(ip);
8111 
8112   return n;
8113 }
8114 
8115 void
8116 consoleinit(void)
8117 {
8118   initlock(&cons.lock, "console");
8119   initlock(&input.lock, "input");
8120 
8121   devsw[CONSOLE].write = consolewrite;
8122   devsw[CONSOLE].read = consoleread;
8123   cons.locking = 1;
8124 
8125   picenable(IRQ_KBD);
8126   ioapicenable(IRQ_KBD, 0);
8127 }
8128 
8129 
8130 
8131 
8132 
8133 
8134 
8135 
8136 
8137 
8138 
8139 
8140 
8141 
8142 
8143 
8144 
8145 
8146 
8147 
8148 
8149 
