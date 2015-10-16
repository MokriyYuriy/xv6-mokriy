
_zombie:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 63 02 00 00       	call   279 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 ed 02 00 00       	call   311 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 55 02 00 00       	call   281 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	5b                   	pop    %ebx
  4e:	5f                   	pop    %edi
  4f:	5d                   	pop    %ebp
  50:	c3                   	ret    

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5d:	90                   	nop
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	8d 50 01             	lea    0x1(%eax),%edx
  64:	89 55 08             	mov    %edx,0x8(%ebp)
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	8d 4a 01             	lea    0x1(%edx),%ecx
  6d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  70:	0f b6 12             	movzbl (%edx),%edx
  73:	88 10                	mov    %dl,(%eax)
  75:	0f b6 00             	movzbl (%eax),%eax
  78:	84 c0                	test   %al,%al
  7a:	75 e2                	jne    5e <strcpy+0xd>
    ;
  return os;
  7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7f:	c9                   	leave  
  80:	c3                   	ret    

00000081 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  81:	55                   	push   %ebp
  82:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  84:	eb 08                	jmp    8e <strcmp+0xd>
    p++, q++;
  86:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8e:	8b 45 08             	mov    0x8(%ebp),%eax
  91:	0f b6 00             	movzbl (%eax),%eax
  94:	84 c0                	test   %al,%al
  96:	74 10                	je     a8 <strcmp+0x27>
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	0f b6 10             	movzbl (%eax),%edx
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	0f b6 00             	movzbl (%eax),%eax
  a4:	38 c2                	cmp    %al,%dl
  a6:	74 de                	je     86 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 d0             	movzbl %al,%edx
  b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  b4:	0f b6 00             	movzbl (%eax),%eax
  b7:	0f b6 c0             	movzbl %al,%eax
  ba:	29 c2                	sub    %eax,%edx
  bc:	89 d0                	mov    %edx,%eax
}
  be:	5d                   	pop    %ebp
  bf:	c3                   	ret    

000000c0 <strlen>:

uint
strlen(char *s)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  cd:	eb 04                	jmp    d3 <strlen+0x13>
  cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	01 d0                	add    %edx,%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	84 c0                	test   %al,%al
  e0:	75 ed                	jne    cf <strlen+0xf>
    ;
  return n;
  e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e5:	c9                   	leave  
  e6:	c3                   	ret    

000000e7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e7:	55                   	push   %ebp
  e8:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  ea:	8b 45 10             	mov    0x10(%ebp),%eax
  ed:	50                   	push   %eax
  ee:	ff 75 0c             	pushl  0xc(%ebp)
  f1:	ff 75 08             	pushl  0x8(%ebp)
  f4:	e8 33 ff ff ff       	call   2c <stosb>
  f9:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  ff:	c9                   	leave  
 100:	c3                   	ret    

00000101 <strchr>:

char*
strchr(const char *s, char c)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	83 ec 04             	sub    $0x4,%esp
 107:	8b 45 0c             	mov    0xc(%ebp),%eax
 10a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10d:	eb 14                	jmp    123 <strchr+0x22>
    if(*s == c)
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	0f b6 00             	movzbl (%eax),%eax
 115:	3a 45 fc             	cmp    -0x4(%ebp),%al
 118:	75 05                	jne    11f <strchr+0x1e>
      return (char*)s;
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	eb 13                	jmp    132 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 00             	movzbl (%eax),%eax
 129:	84 c0                	test   %al,%al
 12b:	75 e2                	jne    10f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 132:	c9                   	leave  
 133:	c3                   	ret    

00000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 141:	eb 44                	jmp    187 <gets+0x53>
    cc = read(0, &c, 1);
 143:	83 ec 04             	sub    $0x4,%esp
 146:	6a 01                	push   $0x1
 148:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14b:	50                   	push   %eax
 14c:	6a 00                	push   $0x0
 14e:	e8 46 01 00 00       	call   299 <read>
 153:	83 c4 10             	add    $0x10,%esp
 156:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 159:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15d:	7f 02                	jg     161 <gets+0x2d>
      break;
 15f:	eb 31                	jmp    192 <gets+0x5e>
    buf[i++] = c;
 161:	8b 45 f4             	mov    -0xc(%ebp),%eax
 164:	8d 50 01             	lea    0x1(%eax),%edx
 167:	89 55 f4             	mov    %edx,-0xc(%ebp)
 16a:	89 c2                	mov    %eax,%edx
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	01 c2                	add    %eax,%edx
 171:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 175:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 177:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17b:	3c 0a                	cmp    $0xa,%al
 17d:	74 13                	je     192 <gets+0x5e>
 17f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 183:	3c 0d                	cmp    $0xd,%al
 185:	74 0b                	je     192 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 187:	8b 45 f4             	mov    -0xc(%ebp),%eax
 18a:	83 c0 01             	add    $0x1,%eax
 18d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 190:	7c b1                	jl     143 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 192:	8b 55 f4             	mov    -0xc(%ebp),%edx
 195:	8b 45 08             	mov    0x8(%ebp),%eax
 198:	01 d0                	add    %edx,%eax
 19a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a0:	c9                   	leave  
 1a1:	c3                   	ret    

000001a2 <stat>:

int
stat(char *n, struct stat *st)
{
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a8:	83 ec 08             	sub    $0x8,%esp
 1ab:	6a 00                	push   $0x0
 1ad:	ff 75 08             	pushl  0x8(%ebp)
 1b0:	e8 0c 01 00 00       	call   2c1 <open>
 1b5:	83 c4 10             	add    $0x10,%esp
 1b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bf:	79 07                	jns    1c8 <stat+0x26>
    return -1;
 1c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c6:	eb 25                	jmp    1ed <stat+0x4b>
  r = fstat(fd, st);
 1c8:	83 ec 08             	sub    $0x8,%esp
 1cb:	ff 75 0c             	pushl  0xc(%ebp)
 1ce:	ff 75 f4             	pushl  -0xc(%ebp)
 1d1:	e8 03 01 00 00       	call   2d9 <fstat>
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1dc:	83 ec 0c             	sub    $0xc,%esp
 1df:	ff 75 f4             	pushl  -0xc(%ebp)
 1e2:	e8 c2 00 00 00       	call   2a9 <close>
 1e7:	83 c4 10             	add    $0x10,%esp
  return r;
 1ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ed:	c9                   	leave  
 1ee:	c3                   	ret    

000001ef <atoi>:

int
atoi(const char *s)
{
 1ef:	55                   	push   %ebp
 1f0:	89 e5                	mov    %esp,%ebp
 1f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1fc:	eb 25                	jmp    223 <atoi+0x34>
    n = n*10 + *s++ - '0';
 1fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
 201:	89 d0                	mov    %edx,%eax
 203:	c1 e0 02             	shl    $0x2,%eax
 206:	01 d0                	add    %edx,%eax
 208:	01 c0                	add    %eax,%eax
 20a:	89 c1                	mov    %eax,%ecx
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	8d 50 01             	lea    0x1(%eax),%edx
 212:	89 55 08             	mov    %edx,0x8(%ebp)
 215:	0f b6 00             	movzbl (%eax),%eax
 218:	0f be c0             	movsbl %al,%eax
 21b:	01 c8                	add    %ecx,%eax
 21d:	83 e8 30             	sub    $0x30,%eax
 220:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	3c 2f                	cmp    $0x2f,%al
 22b:	7e 0a                	jle    237 <atoi+0x48>
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 39                	cmp    $0x39,%al
 235:	7e c7                	jle    1fe <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 237:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 23a:	c9                   	leave  
 23b:	c3                   	ret    

0000023c <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 23c:	55                   	push   %ebp
 23d:	89 e5                	mov    %esp,%ebp
 23f:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 242:	8b 45 08             	mov    0x8(%ebp),%eax
 245:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 248:	8b 45 0c             	mov    0xc(%ebp),%eax
 24b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24e:	eb 17                	jmp    267 <memmove+0x2b>
    *dst++ = *src++;
 250:	8b 45 fc             	mov    -0x4(%ebp),%eax
 253:	8d 50 01             	lea    0x1(%eax),%edx
 256:	89 55 fc             	mov    %edx,-0x4(%ebp)
 259:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25c:	8d 4a 01             	lea    0x1(%edx),%ecx
 25f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 262:	0f b6 12             	movzbl (%edx),%edx
 265:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 267:	8b 45 10             	mov    0x10(%ebp),%eax
 26a:	8d 50 ff             	lea    -0x1(%eax),%edx
 26d:	89 55 10             	mov    %edx,0x10(%ebp)
 270:	85 c0                	test   %eax,%eax
 272:	7f dc                	jg     250 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 279:	b8 01 00 00 00       	mov    $0x1,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <exit>:
SYSCALL(exit)
 281:	b8 02 00 00 00       	mov    $0x2,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <wait>:
SYSCALL(wait)
 289:	b8 03 00 00 00       	mov    $0x3,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <pipe>:
SYSCALL(pipe)
 291:	b8 04 00 00 00       	mov    $0x4,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <read>:
SYSCALL(read)
 299:	b8 05 00 00 00       	mov    $0x5,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <write>:
SYSCALL(write)
 2a1:	b8 10 00 00 00       	mov    $0x10,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <close>:
SYSCALL(close)
 2a9:	b8 15 00 00 00       	mov    $0x15,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <kill>:
SYSCALL(kill)
 2b1:	b8 06 00 00 00       	mov    $0x6,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <exec>:
SYSCALL(exec)
 2b9:	b8 07 00 00 00       	mov    $0x7,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <open>:
SYSCALL(open)
 2c1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <mknod>:
SYSCALL(mknod)
 2c9:	b8 11 00 00 00       	mov    $0x11,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <unlink>:
SYSCALL(unlink)
 2d1:	b8 12 00 00 00       	mov    $0x12,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <fstat>:
SYSCALL(fstat)
 2d9:	b8 08 00 00 00       	mov    $0x8,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <link>:
SYSCALL(link)
 2e1:	b8 13 00 00 00       	mov    $0x13,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <mkdir>:
SYSCALL(mkdir)
 2e9:	b8 14 00 00 00       	mov    $0x14,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <chdir>:
SYSCALL(chdir)
 2f1:	b8 09 00 00 00       	mov    $0x9,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <dup>:
SYSCALL(dup)
 2f9:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <getpid>:
SYSCALL(getpid)
 301:	b8 0b 00 00 00       	mov    $0xb,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <sbrk>:
SYSCALL(sbrk)
 309:	b8 0c 00 00 00       	mov    $0xc,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <sleep>:
SYSCALL(sleep)
 311:	b8 0d 00 00 00       	mov    $0xd,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <uptime>:
SYSCALL(uptime)
 319:	b8 0e 00 00 00       	mov    $0xe,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 18             	sub    $0x18,%esp
 327:	8b 45 0c             	mov    0xc(%ebp),%eax
 32a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 32d:	83 ec 04             	sub    $0x4,%esp
 330:	6a 01                	push   $0x1
 332:	8d 45 f4             	lea    -0xc(%ebp),%eax
 335:	50                   	push   %eax
 336:	ff 75 08             	pushl  0x8(%ebp)
 339:	e8 63 ff ff ff       	call   2a1 <write>
 33e:	83 c4 10             	add    $0x10,%esp
}
 341:	c9                   	leave  
 342:	c3                   	ret    

00000343 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 343:	55                   	push   %ebp
 344:	89 e5                	mov    %esp,%ebp
 346:	53                   	push   %ebx
 347:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 34a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 351:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 355:	74 17                	je     36e <printint+0x2b>
 357:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 35b:	79 11                	jns    36e <printint+0x2b>
    neg = 1;
 35d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	f7 d8                	neg    %eax
 369:	89 45 ec             	mov    %eax,-0x14(%ebp)
 36c:	eb 06                	jmp    374 <printint+0x31>
  } else {
    x = xx;
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 374:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 37b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 37e:	8d 41 01             	lea    0x1(%ecx),%eax
 381:	89 45 f4             	mov    %eax,-0xc(%ebp)
 384:	8b 5d 10             	mov    0x10(%ebp),%ebx
 387:	8b 45 ec             	mov    -0x14(%ebp),%eax
 38a:	ba 00 00 00 00       	mov    $0x0,%edx
 38f:	f7 f3                	div    %ebx
 391:	89 d0                	mov    %edx,%eax
 393:	0f b6 80 fc 09 00 00 	movzbl 0x9fc(%eax),%eax
 39a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 39e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a4:	ba 00 00 00 00       	mov    $0x0,%edx
 3a9:	f7 f3                	div    %ebx
 3ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3b2:	75 c7                	jne    37b <printint+0x38>
  if(neg)
 3b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3b8:	74 0e                	je     3c8 <printint+0x85>
    buf[i++] = '-';
 3ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3bd:	8d 50 01             	lea    0x1(%eax),%edx
 3c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3c3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3c8:	eb 1d                	jmp    3e7 <printint+0xa4>
    putc(fd, buf[i]);
 3ca:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d0:	01 d0                	add    %edx,%eax
 3d2:	0f b6 00             	movzbl (%eax),%eax
 3d5:	0f be c0             	movsbl %al,%eax
 3d8:	83 ec 08             	sub    $0x8,%esp
 3db:	50                   	push   %eax
 3dc:	ff 75 08             	pushl  0x8(%ebp)
 3df:	e8 3d ff ff ff       	call   321 <putc>
 3e4:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3e7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3ef:	79 d9                	jns    3ca <printint+0x87>
    putc(fd, buf[i]);
}
 3f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3f4:	c9                   	leave  
 3f5:	c3                   	ret    

000003f6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 403:	8d 45 0c             	lea    0xc(%ebp),%eax
 406:	83 c0 04             	add    $0x4,%eax
 409:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 40c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 413:	e9 59 01 00 00       	jmp    571 <printf+0x17b>
    c = fmt[i] & 0xff;
 418:	8b 55 0c             	mov    0xc(%ebp),%edx
 41b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 41e:	01 d0                	add    %edx,%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	0f be c0             	movsbl %al,%eax
 426:	25 ff 00 00 00       	and    $0xff,%eax
 42b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 42e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 432:	75 2c                	jne    460 <printf+0x6a>
      if(c == '%'){
 434:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 438:	75 0c                	jne    446 <printf+0x50>
        state = '%';
 43a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 441:	e9 27 01 00 00       	jmp    56d <printf+0x177>
      } else {
        putc(fd, c);
 446:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 449:	0f be c0             	movsbl %al,%eax
 44c:	83 ec 08             	sub    $0x8,%esp
 44f:	50                   	push   %eax
 450:	ff 75 08             	pushl  0x8(%ebp)
 453:	e8 c9 fe ff ff       	call   321 <putc>
 458:	83 c4 10             	add    $0x10,%esp
 45b:	e9 0d 01 00 00       	jmp    56d <printf+0x177>
      }
    } else if(state == '%'){
 460:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 464:	0f 85 03 01 00 00    	jne    56d <printf+0x177>
      if(c == 'd'){
 46a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 46e:	75 1e                	jne    48e <printf+0x98>
        printint(fd, *ap, 10, 1);
 470:	8b 45 e8             	mov    -0x18(%ebp),%eax
 473:	8b 00                	mov    (%eax),%eax
 475:	6a 01                	push   $0x1
 477:	6a 0a                	push   $0xa
 479:	50                   	push   %eax
 47a:	ff 75 08             	pushl  0x8(%ebp)
 47d:	e8 c1 fe ff ff       	call   343 <printint>
 482:	83 c4 10             	add    $0x10,%esp
        ap++;
 485:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 489:	e9 d8 00 00 00       	jmp    566 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 48e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 492:	74 06                	je     49a <printf+0xa4>
 494:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 498:	75 1e                	jne    4b8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 49a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 49d:	8b 00                	mov    (%eax),%eax
 49f:	6a 00                	push   $0x0
 4a1:	6a 10                	push   $0x10
 4a3:	50                   	push   %eax
 4a4:	ff 75 08             	pushl  0x8(%ebp)
 4a7:	e8 97 fe ff ff       	call   343 <printint>
 4ac:	83 c4 10             	add    $0x10,%esp
        ap++;
 4af:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4b3:	e9 ae 00 00 00       	jmp    566 <printf+0x170>
      } else if(c == 's'){
 4b8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4bc:	75 43                	jne    501 <printf+0x10b>
        s = (char*)*ap;
 4be:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4c1:	8b 00                	mov    (%eax),%eax
 4c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ce:	75 07                	jne    4d7 <printf+0xe1>
          s = "(null)";
 4d0:	c7 45 f4 aa 07 00 00 	movl   $0x7aa,-0xc(%ebp)
        while(*s != 0){
 4d7:	eb 1c                	jmp    4f5 <printf+0xff>
          putc(fd, *s);
 4d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4dc:	0f b6 00             	movzbl (%eax),%eax
 4df:	0f be c0             	movsbl %al,%eax
 4e2:	83 ec 08             	sub    $0x8,%esp
 4e5:	50                   	push   %eax
 4e6:	ff 75 08             	pushl  0x8(%ebp)
 4e9:	e8 33 fe ff ff       	call   321 <putc>
 4ee:	83 c4 10             	add    $0x10,%esp
          s++;
 4f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f8:	0f b6 00             	movzbl (%eax),%eax
 4fb:	84 c0                	test   %al,%al
 4fd:	75 da                	jne    4d9 <printf+0xe3>
 4ff:	eb 65                	jmp    566 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 501:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 505:	75 1d                	jne    524 <printf+0x12e>
        putc(fd, *ap);
 507:	8b 45 e8             	mov    -0x18(%ebp),%eax
 50a:	8b 00                	mov    (%eax),%eax
 50c:	0f be c0             	movsbl %al,%eax
 50f:	83 ec 08             	sub    $0x8,%esp
 512:	50                   	push   %eax
 513:	ff 75 08             	pushl  0x8(%ebp)
 516:	e8 06 fe ff ff       	call   321 <putc>
 51b:	83 c4 10             	add    $0x10,%esp
        ap++;
 51e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 522:	eb 42                	jmp    566 <printf+0x170>
      } else if(c == '%'){
 524:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 528:	75 17                	jne    541 <printf+0x14b>
        putc(fd, c);
 52a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52d:	0f be c0             	movsbl %al,%eax
 530:	83 ec 08             	sub    $0x8,%esp
 533:	50                   	push   %eax
 534:	ff 75 08             	pushl  0x8(%ebp)
 537:	e8 e5 fd ff ff       	call   321 <putc>
 53c:	83 c4 10             	add    $0x10,%esp
 53f:	eb 25                	jmp    566 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 541:	83 ec 08             	sub    $0x8,%esp
 544:	6a 25                	push   $0x25
 546:	ff 75 08             	pushl  0x8(%ebp)
 549:	e8 d3 fd ff ff       	call   321 <putc>
 54e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	83 ec 08             	sub    $0x8,%esp
 55a:	50                   	push   %eax
 55b:	ff 75 08             	pushl  0x8(%ebp)
 55e:	e8 be fd ff ff       	call   321 <putc>
 563:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 566:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 56d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 571:	8b 55 0c             	mov    0xc(%ebp),%edx
 574:	8b 45 f0             	mov    -0x10(%ebp),%eax
 577:	01 d0                	add    %edx,%eax
 579:	0f b6 00             	movzbl (%eax),%eax
 57c:	84 c0                	test   %al,%al
 57e:	0f 85 94 fe ff ff    	jne    418 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 584:	c9                   	leave  
 585:	c3                   	ret    

00000586 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 586:	55                   	push   %ebp
 587:	89 e5                	mov    %esp,%ebp
 589:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
 58f:	83 e8 08             	sub    $0x8,%eax
 592:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 595:	a1 18 0a 00 00       	mov    0xa18,%eax
 59a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 59d:	eb 24                	jmp    5c3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a2:	8b 00                	mov    (%eax),%eax
 5a4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5a7:	77 12                	ja     5bb <free+0x35>
 5a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5af:	77 24                	ja     5d5 <free+0x4f>
 5b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b4:	8b 00                	mov    (%eax),%eax
 5b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5b9:	77 1a                	ja     5d5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5be:	8b 00                	mov    (%eax),%eax
 5c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c9:	76 d4                	jbe    59f <free+0x19>
 5cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ce:	8b 00                	mov    (%eax),%eax
 5d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d3:	76 ca                	jbe    59f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d8:	8b 40 04             	mov    0x4(%eax),%eax
 5db:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e5:	01 c2                	add    %eax,%edx
 5e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	39 c2                	cmp    %eax,%edx
 5ee:	75 24                	jne    614 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 5f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f3:	8b 50 04             	mov    0x4(%eax),%edx
 5f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f9:	8b 00                	mov    (%eax),%eax
 5fb:	8b 40 04             	mov    0x4(%eax),%eax
 5fe:	01 c2                	add    %eax,%edx
 600:	8b 45 f8             	mov    -0x8(%ebp),%eax
 603:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 606:	8b 45 fc             	mov    -0x4(%ebp),%eax
 609:	8b 00                	mov    (%eax),%eax
 60b:	8b 10                	mov    (%eax),%edx
 60d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 610:	89 10                	mov    %edx,(%eax)
 612:	eb 0a                	jmp    61e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 10                	mov    (%eax),%edx
 619:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 61e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 621:	8b 40 04             	mov    0x4(%eax),%eax
 624:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 62b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62e:	01 d0                	add    %edx,%eax
 630:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 633:	75 20                	jne    655 <free+0xcf>
    p->s.size += bp->s.size;
 635:	8b 45 fc             	mov    -0x4(%ebp),%eax
 638:	8b 50 04             	mov    0x4(%eax),%edx
 63b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63e:	8b 40 04             	mov    0x4(%eax),%eax
 641:	01 c2                	add    %eax,%edx
 643:	8b 45 fc             	mov    -0x4(%ebp),%eax
 646:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 649:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64c:	8b 10                	mov    (%eax),%edx
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	89 10                	mov    %edx,(%eax)
 653:	eb 08                	jmp    65d <free+0xd7>
  } else
    p->s.ptr = bp;
 655:	8b 45 fc             	mov    -0x4(%ebp),%eax
 658:	8b 55 f8             	mov    -0x8(%ebp),%edx
 65b:	89 10                	mov    %edx,(%eax)
  freep = p;
 65d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 660:	a3 18 0a 00 00       	mov    %eax,0xa18
}
 665:	c9                   	leave  
 666:	c3                   	ret    

00000667 <morecore>:

static Header*
morecore(uint nu)
{
 667:	55                   	push   %ebp
 668:	89 e5                	mov    %esp,%ebp
 66a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 66d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 674:	77 07                	ja     67d <morecore+0x16>
    nu = 4096;
 676:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 67d:	8b 45 08             	mov    0x8(%ebp),%eax
 680:	c1 e0 03             	shl    $0x3,%eax
 683:	83 ec 0c             	sub    $0xc,%esp
 686:	50                   	push   %eax
 687:	e8 7d fc ff ff       	call   309 <sbrk>
 68c:	83 c4 10             	add    $0x10,%esp
 68f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 692:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 696:	75 07                	jne    69f <morecore+0x38>
    return 0;
 698:	b8 00 00 00 00       	mov    $0x0,%eax
 69d:	eb 26                	jmp    6c5 <morecore+0x5e>
  hp = (Header*)p;
 69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a8:	8b 55 08             	mov    0x8(%ebp),%edx
 6ab:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b1:	83 c0 08             	add    $0x8,%eax
 6b4:	83 ec 0c             	sub    $0xc,%esp
 6b7:	50                   	push   %eax
 6b8:	e8 c9 fe ff ff       	call   586 <free>
 6bd:	83 c4 10             	add    $0x10,%esp
  return freep;
 6c0:	a1 18 0a 00 00       	mov    0xa18,%eax
}
 6c5:	c9                   	leave  
 6c6:	c3                   	ret    

000006c7 <malloc>:

void*
malloc(uint nbytes)
{
 6c7:	55                   	push   %ebp
 6c8:	89 e5                	mov    %esp,%ebp
 6ca:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	83 c0 07             	add    $0x7,%eax
 6d3:	c1 e8 03             	shr    $0x3,%eax
 6d6:	83 c0 01             	add    $0x1,%eax
 6d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6dc:	a1 18 0a 00 00       	mov    0xa18,%eax
 6e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e8:	75 23                	jne    70d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6ea:	c7 45 f0 10 0a 00 00 	movl   $0xa10,-0x10(%ebp)
 6f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f4:	a3 18 0a 00 00       	mov    %eax,0xa18
 6f9:	a1 18 0a 00 00       	mov    0xa18,%eax
 6fe:	a3 10 0a 00 00       	mov    %eax,0xa10
    base.s.size = 0;
 703:	c7 05 14 0a 00 00 00 	movl   $0x0,0xa14
 70a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 715:	8b 45 f4             	mov    -0xc(%ebp),%eax
 718:	8b 40 04             	mov    0x4(%eax),%eax
 71b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 71e:	72 4d                	jb     76d <malloc+0xa6>
      if(p->s.size == nunits)
 720:	8b 45 f4             	mov    -0xc(%ebp),%eax
 723:	8b 40 04             	mov    0x4(%eax),%eax
 726:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 729:	75 0c                	jne    737 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 72b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72e:	8b 10                	mov    (%eax),%edx
 730:	8b 45 f0             	mov    -0x10(%ebp),%eax
 733:	89 10                	mov    %edx,(%eax)
 735:	eb 26                	jmp    75d <malloc+0x96>
      else {
        p->s.size -= nunits;
 737:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 740:	89 c2                	mov    %eax,%edx
 742:	8b 45 f4             	mov    -0xc(%ebp),%eax
 745:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 748:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	c1 e0 03             	shl    $0x3,%eax
 751:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 754:	8b 45 f4             	mov    -0xc(%ebp),%eax
 757:	8b 55 ec             	mov    -0x14(%ebp),%edx
 75a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	a3 18 0a 00 00       	mov    %eax,0xa18
      return (void*)(p + 1);
 765:	8b 45 f4             	mov    -0xc(%ebp),%eax
 768:	83 c0 08             	add    $0x8,%eax
 76b:	eb 3b                	jmp    7a8 <malloc+0xe1>
    }
    if(p == freep)
 76d:	a1 18 0a 00 00       	mov    0xa18,%eax
 772:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 775:	75 1e                	jne    795 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 777:	83 ec 0c             	sub    $0xc,%esp
 77a:	ff 75 ec             	pushl  -0x14(%ebp)
 77d:	e8 e5 fe ff ff       	call   667 <morecore>
 782:	83 c4 10             	add    $0x10,%esp
 785:	89 45 f4             	mov    %eax,-0xc(%ebp)
 788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 78c:	75 07                	jne    795 <malloc+0xce>
        return 0;
 78e:	b8 00 00 00 00       	mov    $0x0,%eax
 793:	eb 13                	jmp    7a8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 795:	8b 45 f4             	mov    -0xc(%ebp),%eax
 798:	89 45 f0             	mov    %eax,-0x10(%ebp)
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 00                	mov    (%eax),%eax
 7a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7a3:	e9 6d ff ff ff       	jmp    715 <malloc+0x4e>
}
 7a8:	c9                   	leave  
 7a9:	c3                   	ret    
