
_helloworld:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *args[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    printf(1, "Hello, world!\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 a6 07 00 00       	push   $0x7a6
  19:	6a 01                	push   $0x1
  1b:	e8 d2 03 00 00       	call   3f2 <printf>
  20:	83 c4 10             	add    $0x10,%esp
    exit();
  23:	e8 55 02 00 00       	call   27d <exit>

00000028 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	57                   	push   %edi
  2c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  30:	8b 55 10             	mov    0x10(%ebp),%edx
  33:	8b 45 0c             	mov    0xc(%ebp),%eax
  36:	89 cb                	mov    %ecx,%ebx
  38:	89 df                	mov    %ebx,%edi
  3a:	89 d1                	mov    %edx,%ecx
  3c:	fc                   	cld    
  3d:	f3 aa                	rep stos %al,%es:(%edi)
  3f:	89 ca                	mov    %ecx,%edx
  41:	89 fb                	mov    %edi,%ebx
  43:	89 5d 08             	mov    %ebx,0x8(%ebp)
  46:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  49:	5b                   	pop    %ebx
  4a:	5f                   	pop    %edi
  4b:	5d                   	pop    %ebp
  4c:	c3                   	ret    

0000004d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4d:	55                   	push   %ebp
  4e:	89 e5                	mov    %esp,%ebp
  50:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  53:	8b 45 08             	mov    0x8(%ebp),%eax
  56:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  59:	90                   	nop
  5a:	8b 45 08             	mov    0x8(%ebp),%eax
  5d:	8d 50 01             	lea    0x1(%eax),%edx
  60:	89 55 08             	mov    %edx,0x8(%ebp)
  63:	8b 55 0c             	mov    0xc(%ebp),%edx
  66:	8d 4a 01             	lea    0x1(%edx),%ecx
  69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  6c:	0f b6 12             	movzbl (%edx),%edx
  6f:	88 10                	mov    %dl,(%eax)
  71:	0f b6 00             	movzbl (%eax),%eax
  74:	84 c0                	test   %al,%al
  76:	75 e2                	jne    5a <strcpy+0xd>
    ;
  return os;
  78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7b:	c9                   	leave  
  7c:	c3                   	ret    

0000007d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7d:	55                   	push   %ebp
  7e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  80:	eb 08                	jmp    8a <strcmp+0xd>
    p++, q++;
  82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  86:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8a:	8b 45 08             	mov    0x8(%ebp),%eax
  8d:	0f b6 00             	movzbl (%eax),%eax
  90:	84 c0                	test   %al,%al
  92:	74 10                	je     a4 <strcmp+0x27>
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	0f b6 10             	movzbl (%eax),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	0f b6 00             	movzbl (%eax),%eax
  a0:	38 c2                	cmp    %al,%dl
  a2:	74 de                	je     82 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a4:	8b 45 08             	mov    0x8(%ebp),%eax
  a7:	0f b6 00             	movzbl (%eax),%eax
  aa:	0f b6 d0             	movzbl %al,%edx
  ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  b0:	0f b6 00             	movzbl (%eax),%eax
  b3:	0f b6 c0             	movzbl %al,%eax
  b6:	29 c2                	sub    %eax,%edx
  b8:	89 d0                	mov    %edx,%eax
}
  ba:	5d                   	pop    %ebp
  bb:	c3                   	ret    

000000bc <strlen>:

uint
strlen(char *s)
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c9:	eb 04                	jmp    cf <strlen+0x13>
  cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	01 d0                	add    %edx,%eax
  d7:	0f b6 00             	movzbl (%eax),%eax
  da:	84 c0                	test   %al,%al
  dc:	75 ed                	jne    cb <strlen+0xf>
    ;
  return n;
  de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e1:	c9                   	leave  
  e2:	c3                   	ret    

000000e3 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e6:	8b 45 10             	mov    0x10(%ebp),%eax
  e9:	50                   	push   %eax
  ea:	ff 75 0c             	pushl  0xc(%ebp)
  ed:	ff 75 08             	pushl  0x8(%ebp)
  f0:	e8 33 ff ff ff       	call   28 <stosb>
  f5:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <strchr>:

char*
strchr(const char *s, char c)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 04             	sub    $0x4,%esp
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 109:	eb 14                	jmp    11f <strchr+0x22>
    if(*s == c)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	3a 45 fc             	cmp    -0x4(%ebp),%al
 114:	75 05                	jne    11b <strchr+0x1e>
      return (char*)s;
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	eb 13                	jmp    12e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 e2                	jne    10b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 129:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 136:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13d:	eb 44                	jmp    183 <gets+0x53>
    cc = read(0, &c, 1);
 13f:	83 ec 04             	sub    $0x4,%esp
 142:	6a 01                	push   $0x1
 144:	8d 45 ef             	lea    -0x11(%ebp),%eax
 147:	50                   	push   %eax
 148:	6a 00                	push   $0x0
 14a:	e8 46 01 00 00       	call   295 <read>
 14f:	83 c4 10             	add    $0x10,%esp
 152:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 159:	7f 02                	jg     15d <gets+0x2d>
      break;
 15b:	eb 31                	jmp    18e <gets+0x5e>
    buf[i++] = c;
 15d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 160:	8d 50 01             	lea    0x1(%eax),%edx
 163:	89 55 f4             	mov    %edx,-0xc(%ebp)
 166:	89 c2                	mov    %eax,%edx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	01 c2                	add    %eax,%edx
 16d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 171:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 173:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 177:	3c 0a                	cmp    $0xa,%al
 179:	74 13                	je     18e <gets+0x5e>
 17b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17f:	3c 0d                	cmp    $0xd,%al
 181:	74 0b                	je     18e <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	8b 45 f4             	mov    -0xc(%ebp),%eax
 186:	83 c0 01             	add    $0x1,%eax
 189:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18c:	7c b1                	jl     13f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 18e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	01 d0                	add    %edx,%eax
 196:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <stat>:

int
stat(char *n, struct stat *st)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	6a 00                	push   $0x0
 1a9:	ff 75 08             	pushl  0x8(%ebp)
 1ac:	e8 0c 01 00 00       	call   2bd <open>
 1b1:	83 c4 10             	add    $0x10,%esp
 1b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bb:	79 07                	jns    1c4 <stat+0x26>
    return -1;
 1bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c2:	eb 25                	jmp    1e9 <stat+0x4b>
  r = fstat(fd, st);
 1c4:	83 ec 08             	sub    $0x8,%esp
 1c7:	ff 75 0c             	pushl  0xc(%ebp)
 1ca:	ff 75 f4             	pushl  -0xc(%ebp)
 1cd:	e8 03 01 00 00       	call   2d5 <fstat>
 1d2:	83 c4 10             	add    $0x10,%esp
 1d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d8:	83 ec 0c             	sub    $0xc,%esp
 1db:	ff 75 f4             	pushl  -0xc(%ebp)
 1de:	e8 c2 00 00 00       	call   2a5 <close>
 1e3:	83 c4 10             	add    $0x10,%esp
  return r;
 1e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e9:	c9                   	leave  
 1ea:	c3                   	ret    

000001eb <atoi>:

int
atoi(const char *s)
{
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f8:	eb 25                	jmp    21f <atoi+0x34>
    n = n*10 + *s++ - '0';
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	89 d0                	mov    %edx,%eax
 1ff:	c1 e0 02             	shl    $0x2,%eax
 202:	01 d0                	add    %edx,%eax
 204:	01 c0                	add    %eax,%eax
 206:	89 c1                	mov    %eax,%ecx
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	8d 50 01             	lea    0x1(%eax),%edx
 20e:	89 55 08             	mov    %edx,0x8(%ebp)
 211:	0f b6 00             	movzbl (%eax),%eax
 214:	0f be c0             	movsbl %al,%eax
 217:	01 c8                	add    %ecx,%eax
 219:	83 e8 30             	sub    $0x30,%eax
 21c:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	3c 2f                	cmp    $0x2f,%al
 227:	7e 0a                	jle    233 <atoi+0x48>
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3c 39                	cmp    $0x39,%al
 231:	7e c7                	jle    1fa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 233:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 24a:	eb 17                	jmp    263 <memmove+0x2b>
    *dst++ = *src++;
 24c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 24f:	8d 50 01             	lea    0x1(%eax),%edx
 252:	89 55 fc             	mov    %edx,-0x4(%ebp)
 255:	8b 55 f8             	mov    -0x8(%ebp),%edx
 258:	8d 4a 01             	lea    0x1(%edx),%ecx
 25b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 25e:	0f b6 12             	movzbl (%edx),%edx
 261:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 263:	8b 45 10             	mov    0x10(%ebp),%eax
 266:	8d 50 ff             	lea    -0x1(%eax),%edx
 269:	89 55 10             	mov    %edx,0x10(%ebp)
 26c:	85 c0                	test   %eax,%eax
 26e:	7f dc                	jg     24c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 275:	b8 01 00 00 00       	mov    $0x1,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <exit>:
SYSCALL(exit)
 27d:	b8 02 00 00 00       	mov    $0x2,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <wait>:
SYSCALL(wait)
 285:	b8 03 00 00 00       	mov    $0x3,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <pipe>:
SYSCALL(pipe)
 28d:	b8 04 00 00 00       	mov    $0x4,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <read>:
SYSCALL(read)
 295:	b8 05 00 00 00       	mov    $0x5,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <write>:
SYSCALL(write)
 29d:	b8 10 00 00 00       	mov    $0x10,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <close>:
SYSCALL(close)
 2a5:	b8 15 00 00 00       	mov    $0x15,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <kill>:
SYSCALL(kill)
 2ad:	b8 06 00 00 00       	mov    $0x6,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <exec>:
SYSCALL(exec)
 2b5:	b8 07 00 00 00       	mov    $0x7,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <open>:
SYSCALL(open)
 2bd:	b8 0f 00 00 00       	mov    $0xf,%eax
 2c2:	cd 40                	int    $0x40
 2c4:	c3                   	ret    

000002c5 <mknod>:
SYSCALL(mknod)
 2c5:	b8 11 00 00 00       	mov    $0x11,%eax
 2ca:	cd 40                	int    $0x40
 2cc:	c3                   	ret    

000002cd <unlink>:
SYSCALL(unlink)
 2cd:	b8 12 00 00 00       	mov    $0x12,%eax
 2d2:	cd 40                	int    $0x40
 2d4:	c3                   	ret    

000002d5 <fstat>:
SYSCALL(fstat)
 2d5:	b8 08 00 00 00       	mov    $0x8,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <link>:
SYSCALL(link)
 2dd:	b8 13 00 00 00       	mov    $0x13,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <mkdir>:
SYSCALL(mkdir)
 2e5:	b8 14 00 00 00       	mov    $0x14,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <chdir>:
SYSCALL(chdir)
 2ed:	b8 09 00 00 00       	mov    $0x9,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <dup>:
SYSCALL(dup)
 2f5:	b8 0a 00 00 00       	mov    $0xa,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <getpid>:
SYSCALL(getpid)
 2fd:	b8 0b 00 00 00       	mov    $0xb,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <sbrk>:
SYSCALL(sbrk)
 305:	b8 0c 00 00 00       	mov    $0xc,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <sleep>:
SYSCALL(sleep)
 30d:	b8 0d 00 00 00       	mov    $0xd,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <uptime>:
SYSCALL(uptime)
 315:	b8 0e 00 00 00       	mov    $0xe,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 31d:	55                   	push   %ebp
 31e:	89 e5                	mov    %esp,%ebp
 320:	83 ec 18             	sub    $0x18,%esp
 323:	8b 45 0c             	mov    0xc(%ebp),%eax
 326:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 329:	83 ec 04             	sub    $0x4,%esp
 32c:	6a 01                	push   $0x1
 32e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 331:	50                   	push   %eax
 332:	ff 75 08             	pushl  0x8(%ebp)
 335:	e8 63 ff ff ff       	call   29d <write>
 33a:	83 c4 10             	add    $0x10,%esp
}
 33d:	c9                   	leave  
 33e:	c3                   	ret    

0000033f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	53                   	push   %ebx
 343:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 346:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 34d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 351:	74 17                	je     36a <printint+0x2b>
 353:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 357:	79 11                	jns    36a <printint+0x2b>
    neg = 1;
 359:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	f7 d8                	neg    %eax
 365:	89 45 ec             	mov    %eax,-0x14(%ebp)
 368:	eb 06                	jmp    370 <printint+0x31>
  } else {
    x = xx;
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 370:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 377:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 37a:	8d 41 01             	lea    0x1(%ecx),%eax
 37d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 380:	8b 5d 10             	mov    0x10(%ebp),%ebx
 383:	8b 45 ec             	mov    -0x14(%ebp),%eax
 386:	ba 00 00 00 00       	mov    $0x0,%edx
 38b:	f7 f3                	div    %ebx
 38d:	89 d0                	mov    %edx,%eax
 38f:	0f b6 80 04 0a 00 00 	movzbl 0xa04(%eax),%eax
 396:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 39a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 39d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a0:	ba 00 00 00 00       	mov    $0x0,%edx
 3a5:	f7 f3                	div    %ebx
 3a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3ae:	75 c7                	jne    377 <printint+0x38>
  if(neg)
 3b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3b4:	74 0e                	je     3c4 <printint+0x85>
    buf[i++] = '-';
 3b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b9:	8d 50 01             	lea    0x1(%eax),%edx
 3bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3bf:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3c4:	eb 1d                	jmp    3e3 <printint+0xa4>
    putc(fd, buf[i]);
 3c6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cc:	01 d0                	add    %edx,%eax
 3ce:	0f b6 00             	movzbl (%eax),%eax
 3d1:	0f be c0             	movsbl %al,%eax
 3d4:	83 ec 08             	sub    $0x8,%esp
 3d7:	50                   	push   %eax
 3d8:	ff 75 08             	pushl  0x8(%ebp)
 3db:	e8 3d ff ff ff       	call   31d <putc>
 3e0:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3e3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 3e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3eb:	79 d9                	jns    3c6 <printint+0x87>
    putc(fd, buf[i]);
}
 3ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 3ff:	8d 45 0c             	lea    0xc(%ebp),%eax
 402:	83 c0 04             	add    $0x4,%eax
 405:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 408:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 40f:	e9 59 01 00 00       	jmp    56d <printf+0x17b>
    c = fmt[i] & 0xff;
 414:	8b 55 0c             	mov    0xc(%ebp),%edx
 417:	8b 45 f0             	mov    -0x10(%ebp),%eax
 41a:	01 d0                	add    %edx,%eax
 41c:	0f b6 00             	movzbl (%eax),%eax
 41f:	0f be c0             	movsbl %al,%eax
 422:	25 ff 00 00 00       	and    $0xff,%eax
 427:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 42a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 42e:	75 2c                	jne    45c <printf+0x6a>
      if(c == '%'){
 430:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 434:	75 0c                	jne    442 <printf+0x50>
        state = '%';
 436:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 43d:	e9 27 01 00 00       	jmp    569 <printf+0x177>
      } else {
        putc(fd, c);
 442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 445:	0f be c0             	movsbl %al,%eax
 448:	83 ec 08             	sub    $0x8,%esp
 44b:	50                   	push   %eax
 44c:	ff 75 08             	pushl  0x8(%ebp)
 44f:	e8 c9 fe ff ff       	call   31d <putc>
 454:	83 c4 10             	add    $0x10,%esp
 457:	e9 0d 01 00 00       	jmp    569 <printf+0x177>
      }
    } else if(state == '%'){
 45c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 460:	0f 85 03 01 00 00    	jne    569 <printf+0x177>
      if(c == 'd'){
 466:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 46a:	75 1e                	jne    48a <printf+0x98>
        printint(fd, *ap, 10, 1);
 46c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 46f:	8b 00                	mov    (%eax),%eax
 471:	6a 01                	push   $0x1
 473:	6a 0a                	push   $0xa
 475:	50                   	push   %eax
 476:	ff 75 08             	pushl  0x8(%ebp)
 479:	e8 c1 fe ff ff       	call   33f <printint>
 47e:	83 c4 10             	add    $0x10,%esp
        ap++;
 481:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 485:	e9 d8 00 00 00       	jmp    562 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 48a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 48e:	74 06                	je     496 <printf+0xa4>
 490:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 494:	75 1e                	jne    4b4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 496:	8b 45 e8             	mov    -0x18(%ebp),%eax
 499:	8b 00                	mov    (%eax),%eax
 49b:	6a 00                	push   $0x0
 49d:	6a 10                	push   $0x10
 49f:	50                   	push   %eax
 4a0:	ff 75 08             	pushl  0x8(%ebp)
 4a3:	e8 97 fe ff ff       	call   33f <printint>
 4a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4af:	e9 ae 00 00 00       	jmp    562 <printf+0x170>
      } else if(c == 's'){
 4b4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4b8:	75 43                	jne    4fd <printf+0x10b>
        s = (char*)*ap;
 4ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bd:	8b 00                	mov    (%eax),%eax
 4bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ca:	75 07                	jne    4d3 <printf+0xe1>
          s = "(null)";
 4cc:	c7 45 f4 b5 07 00 00 	movl   $0x7b5,-0xc(%ebp)
        while(*s != 0){
 4d3:	eb 1c                	jmp    4f1 <printf+0xff>
          putc(fd, *s);
 4d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d8:	0f b6 00             	movzbl (%eax),%eax
 4db:	0f be c0             	movsbl %al,%eax
 4de:	83 ec 08             	sub    $0x8,%esp
 4e1:	50                   	push   %eax
 4e2:	ff 75 08             	pushl  0x8(%ebp)
 4e5:	e8 33 fe ff ff       	call   31d <putc>
 4ea:	83 c4 10             	add    $0x10,%esp
          s++;
 4ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 4f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4f4:	0f b6 00             	movzbl (%eax),%eax
 4f7:	84 c0                	test   %al,%al
 4f9:	75 da                	jne    4d5 <printf+0xe3>
 4fb:	eb 65                	jmp    562 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 501:	75 1d                	jne    520 <printf+0x12e>
        putc(fd, *ap);
 503:	8b 45 e8             	mov    -0x18(%ebp),%eax
 506:	8b 00                	mov    (%eax),%eax
 508:	0f be c0             	movsbl %al,%eax
 50b:	83 ec 08             	sub    $0x8,%esp
 50e:	50                   	push   %eax
 50f:	ff 75 08             	pushl  0x8(%ebp)
 512:	e8 06 fe ff ff       	call   31d <putc>
 517:	83 c4 10             	add    $0x10,%esp
        ap++;
 51a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51e:	eb 42                	jmp    562 <printf+0x170>
      } else if(c == '%'){
 520:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 524:	75 17                	jne    53d <printf+0x14b>
        putc(fd, c);
 526:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 529:	0f be c0             	movsbl %al,%eax
 52c:	83 ec 08             	sub    $0x8,%esp
 52f:	50                   	push   %eax
 530:	ff 75 08             	pushl  0x8(%ebp)
 533:	e8 e5 fd ff ff       	call   31d <putc>
 538:	83 c4 10             	add    $0x10,%esp
 53b:	eb 25                	jmp    562 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 53d:	83 ec 08             	sub    $0x8,%esp
 540:	6a 25                	push   $0x25
 542:	ff 75 08             	pushl  0x8(%ebp)
 545:	e8 d3 fd ff ff       	call   31d <putc>
 54a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 54d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 550:	0f be c0             	movsbl %al,%eax
 553:	83 ec 08             	sub    $0x8,%esp
 556:	50                   	push   %eax
 557:	ff 75 08             	pushl  0x8(%ebp)
 55a:	e8 be fd ff ff       	call   31d <putc>
 55f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 562:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 569:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 56d:	8b 55 0c             	mov    0xc(%ebp),%edx
 570:	8b 45 f0             	mov    -0x10(%ebp),%eax
 573:	01 d0                	add    %edx,%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	84 c0                	test   %al,%al
 57a:	0f 85 94 fe ff ff    	jne    414 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 580:	c9                   	leave  
 581:	c3                   	ret    

00000582 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	83 e8 08             	sub    $0x8,%eax
 58e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	a1 20 0a 00 00       	mov    0xa20,%eax
 596:	89 45 fc             	mov    %eax,-0x4(%ebp)
 599:	eb 24                	jmp    5bf <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 59e:	8b 00                	mov    (%eax),%eax
 5a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5a3:	77 12                	ja     5b7 <free+0x35>
 5a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ab:	77 24                	ja     5d1 <free+0x4f>
 5ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5b0:	8b 00                	mov    (%eax),%eax
 5b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5b5:	77 1a                	ja     5d1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c5:	76 d4                	jbe    59b <free+0x19>
 5c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ca:	8b 00                	mov    (%eax),%eax
 5cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5cf:	76 ca                	jbe    59b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5d4:	8b 40 04             	mov    0x4(%eax),%eax
 5d7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 5de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e1:	01 c2                	add    %eax,%edx
 5e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e6:	8b 00                	mov    (%eax),%eax
 5e8:	39 c2                	cmp    %eax,%edx
 5ea:	75 24                	jne    610 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 5ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ef:	8b 50 04             	mov    0x4(%eax),%edx
 5f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	8b 40 04             	mov    0x4(%eax),%eax
 5fa:	01 c2                	add    %eax,%edx
 5fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ff:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 602:	8b 45 fc             	mov    -0x4(%ebp),%eax
 605:	8b 00                	mov    (%eax),%eax
 607:	8b 10                	mov    (%eax),%edx
 609:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60c:	89 10                	mov    %edx,(%eax)
 60e:	eb 0a                	jmp    61a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 610:	8b 45 fc             	mov    -0x4(%ebp),%eax
 613:	8b 10                	mov    (%eax),%edx
 615:	8b 45 f8             	mov    -0x8(%ebp),%eax
 618:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 61a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61d:	8b 40 04             	mov    0x4(%eax),%eax
 620:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 627:	8b 45 fc             	mov    -0x4(%ebp),%eax
 62a:	01 d0                	add    %edx,%eax
 62c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 62f:	75 20                	jne    651 <free+0xcf>
    p->s.size += bp->s.size;
 631:	8b 45 fc             	mov    -0x4(%ebp),%eax
 634:	8b 50 04             	mov    0x4(%eax),%edx
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	8b 40 04             	mov    0x4(%eax),%eax
 63d:	01 c2                	add    %eax,%edx
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 645:	8b 45 f8             	mov    -0x8(%ebp),%eax
 648:	8b 10                	mov    (%eax),%edx
 64a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64d:	89 10                	mov    %edx,(%eax)
 64f:	eb 08                	jmp    659 <free+0xd7>
  } else
    p->s.ptr = bp;
 651:	8b 45 fc             	mov    -0x4(%ebp),%eax
 654:	8b 55 f8             	mov    -0x8(%ebp),%edx
 657:	89 10                	mov    %edx,(%eax)
  freep = p;
 659:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65c:	a3 20 0a 00 00       	mov    %eax,0xa20
}
 661:	c9                   	leave  
 662:	c3                   	ret    

00000663 <morecore>:

static Header*
morecore(uint nu)
{
 663:	55                   	push   %ebp
 664:	89 e5                	mov    %esp,%ebp
 666:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 669:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 670:	77 07                	ja     679 <morecore+0x16>
    nu = 4096;
 672:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 679:	8b 45 08             	mov    0x8(%ebp),%eax
 67c:	c1 e0 03             	shl    $0x3,%eax
 67f:	83 ec 0c             	sub    $0xc,%esp
 682:	50                   	push   %eax
 683:	e8 7d fc ff ff       	call   305 <sbrk>
 688:	83 c4 10             	add    $0x10,%esp
 68b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 68e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 692:	75 07                	jne    69b <morecore+0x38>
    return 0;
 694:	b8 00 00 00 00       	mov    $0x0,%eax
 699:	eb 26                	jmp    6c1 <morecore+0x5e>
  hp = (Header*)p;
 69b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a4:	8b 55 08             	mov    0x8(%ebp),%edx
 6a7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ad:	83 c0 08             	add    $0x8,%eax
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	50                   	push   %eax
 6b4:	e8 c9 fe ff ff       	call   582 <free>
 6b9:	83 c4 10             	add    $0x10,%esp
  return freep;
 6bc:	a1 20 0a 00 00       	mov    0xa20,%eax
}
 6c1:	c9                   	leave  
 6c2:	c3                   	ret    

000006c3 <malloc>:

void*
malloc(uint nbytes)
{
 6c3:	55                   	push   %ebp
 6c4:	89 e5                	mov    %esp,%ebp
 6c6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c9:	8b 45 08             	mov    0x8(%ebp),%eax
 6cc:	83 c0 07             	add    $0x7,%eax
 6cf:	c1 e8 03             	shr    $0x3,%eax
 6d2:	83 c0 01             	add    $0x1,%eax
 6d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6d8:	a1 20 0a 00 00       	mov    0xa20,%eax
 6dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e4:	75 23                	jne    709 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 6e6:	c7 45 f0 18 0a 00 00 	movl   $0xa18,-0x10(%ebp)
 6ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f0:	a3 20 0a 00 00       	mov    %eax,0xa20
 6f5:	a1 20 0a 00 00       	mov    0xa20,%eax
 6fa:	a3 18 0a 00 00       	mov    %eax,0xa18
    base.s.size = 0;
 6ff:	c7 05 1c 0a 00 00 00 	movl   $0x0,0xa1c
 706:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 711:	8b 45 f4             	mov    -0xc(%ebp),%eax
 714:	8b 40 04             	mov    0x4(%eax),%eax
 717:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 71a:	72 4d                	jb     769 <malloc+0xa6>
      if(p->s.size == nunits)
 71c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 71f:	8b 40 04             	mov    0x4(%eax),%eax
 722:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 725:	75 0c                	jne    733 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 727:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72a:	8b 10                	mov    (%eax),%edx
 72c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72f:	89 10                	mov    %edx,(%eax)
 731:	eb 26                	jmp    759 <malloc+0x96>
      else {
        p->s.size -= nunits;
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	2b 45 ec             	sub    -0x14(%ebp),%eax
 73c:	89 c2                	mov    %eax,%edx
 73e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 741:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 744:	8b 45 f4             	mov    -0xc(%ebp),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	c1 e0 03             	shl    $0x3,%eax
 74d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 750:	8b 45 f4             	mov    -0xc(%ebp),%eax
 753:	8b 55 ec             	mov    -0x14(%ebp),%edx
 756:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 759:	8b 45 f0             	mov    -0x10(%ebp),%eax
 75c:	a3 20 0a 00 00       	mov    %eax,0xa20
      return (void*)(p + 1);
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	83 c0 08             	add    $0x8,%eax
 767:	eb 3b                	jmp    7a4 <malloc+0xe1>
    }
    if(p == freep)
 769:	a1 20 0a 00 00       	mov    0xa20,%eax
 76e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 771:	75 1e                	jne    791 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 773:	83 ec 0c             	sub    $0xc,%esp
 776:	ff 75 ec             	pushl  -0x14(%ebp)
 779:	e8 e5 fe ff ff       	call   663 <morecore>
 77e:	83 c4 10             	add    $0x10,%esp
 781:	89 45 f4             	mov    %eax,-0xc(%ebp)
 784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 788:	75 07                	jne    791 <malloc+0xce>
        return 0;
 78a:	b8 00 00 00 00       	mov    $0x0,%eax
 78f:	eb 13                	jmp    7a4 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	89 45 f0             	mov    %eax,-0x10(%ebp)
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 79f:	e9 6d ff ff ff       	jmp    711 <malloc+0x4e>
}
 7a4:	c9                   	leave  
 7a5:	c3                   	ret    
