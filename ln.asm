
_ln:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 f2 07 00 00       	push   $0x7f2
  1e:	6a 02                	push   $0x2
  20:	e8 19 04 00 00       	call   43e <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9c 02 00 00       	call   2c9 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e2 02 00 00       	call   329 <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 05 08 00 00       	push   $0x805
  65:	6a 02                	push   $0x2
  67:	e8 d2 03 00 00       	call   43e <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 55 02 00 00       	call   2c9 <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	5b                   	pop    %ebx
  96:	5f                   	pop    %edi
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    

00000099 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a5:	90                   	nop
  a6:	8b 45 08             	mov    0x8(%ebp),%eax
  a9:	8d 50 01             	lea    0x1(%eax),%edx
  ac:	89 55 08             	mov    %edx,0x8(%ebp)
  af:	8b 55 0c             	mov    0xc(%ebp),%edx
  b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  b5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b8:	0f b6 12             	movzbl (%edx),%edx
  bb:	88 10                	mov    %dl,(%eax)
  bd:	0f b6 00             	movzbl (%eax),%eax
  c0:	84 c0                	test   %al,%al
  c2:	75 e2                	jne    a6 <strcpy+0xd>
    ;
  return os;
  c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c7:	c9                   	leave  
  c8:	c3                   	ret    

000000c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cc:	eb 08                	jmp    d6 <strcmp+0xd>
    p++, q++;
  ce:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d2:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d6:	8b 45 08             	mov    0x8(%ebp),%eax
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	74 10                	je     f0 <strcmp+0x27>
  e0:	8b 45 08             	mov    0x8(%ebp),%eax
  e3:	0f b6 10             	movzbl (%eax),%edx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	0f b6 00             	movzbl (%eax),%eax
  ec:	38 c2                	cmp    %al,%dl
  ee:	74 de                	je     ce <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	0f b6 d0             	movzbl %al,%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	0f b6 00             	movzbl (%eax),%eax
  ff:	0f b6 c0             	movzbl %al,%eax
 102:	29 c2                	sub    %eax,%edx
 104:	89 d0                	mov    %edx,%eax
}
 106:	5d                   	pop    %ebp
 107:	c3                   	ret    

00000108 <strlen>:

uint
strlen(char *s)
{
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 115:	eb 04                	jmp    11b <strlen+0x13>
 117:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11e:	8b 45 08             	mov    0x8(%ebp),%eax
 121:	01 d0                	add    %edx,%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	75 ed                	jne    117 <strlen+0xf>
    ;
  return n;
 12a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12d:	c9                   	leave  
 12e:	c3                   	ret    

0000012f <memset>:

void*
memset(void *dst, int c, uint n)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 132:	8b 45 10             	mov    0x10(%ebp),%eax
 135:	50                   	push   %eax
 136:	ff 75 0c             	pushl  0xc(%ebp)
 139:	ff 75 08             	pushl  0x8(%ebp)
 13c:	e8 33 ff ff ff       	call   74 <stosb>
 141:	83 c4 0c             	add    $0xc,%esp
  return dst;
 144:	8b 45 08             	mov    0x8(%ebp),%eax
}
 147:	c9                   	leave  
 148:	c3                   	ret    

00000149 <strchr>:

char*
strchr(const char *s, char c)
{
 149:	55                   	push   %ebp
 14a:	89 e5                	mov    %esp,%ebp
 14c:	83 ec 04             	sub    $0x4,%esp
 14f:	8b 45 0c             	mov    0xc(%ebp),%eax
 152:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 155:	eb 14                	jmp    16b <strchr+0x22>
    if(*s == c)
 157:	8b 45 08             	mov    0x8(%ebp),%eax
 15a:	0f b6 00             	movzbl (%eax),%eax
 15d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 160:	75 05                	jne    167 <strchr+0x1e>
      return (char*)s;
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	eb 13                	jmp    17a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 167:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	84 c0                	test   %al,%al
 173:	75 e2                	jne    157 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 175:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17a:	c9                   	leave  
 17b:	c3                   	ret    

0000017c <gets>:

char*
gets(char *buf, int max)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 189:	eb 44                	jmp    1cf <gets+0x53>
    cc = read(0, &c, 1);
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	6a 01                	push   $0x1
 190:	8d 45 ef             	lea    -0x11(%ebp),%eax
 193:	50                   	push   %eax
 194:	6a 00                	push   $0x0
 196:	e8 46 01 00 00       	call   2e1 <read>
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a5:	7f 02                	jg     1a9 <gets+0x2d>
      break;
 1a7:	eb 31                	jmp    1da <gets+0x5e>
    buf[i++] = c;
 1a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ac:	8d 50 01             	lea    0x1(%eax),%edx
 1af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b2:	89 c2                	mov    %eax,%edx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	01 c2                	add    %eax,%edx
 1b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c3:	3c 0a                	cmp    $0xa,%al
 1c5:	74 13                	je     1da <gets+0x5e>
 1c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cb:	3c 0d                	cmp    $0xd,%al
 1cd:	74 0b                	je     1da <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d2:	83 c0 01             	add    $0x1,%eax
 1d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d8:	7c b1                	jl     18b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 0c 01 00 00       	call   309 <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 03 01 00 00       	call   321 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 c2 00 00 00       	call   2f1 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 244:	eb 25                	jmp    26b <atoi+0x34>
    n = n*10 + *s++ - '0';
 246:	8b 55 fc             	mov    -0x4(%ebp),%edx
 249:	89 d0                	mov    %edx,%eax
 24b:	c1 e0 02             	shl    $0x2,%eax
 24e:	01 d0                	add    %edx,%eax
 250:	01 c0                	add    %eax,%eax
 252:	89 c1                	mov    %eax,%ecx
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8d 50 01             	lea    0x1(%eax),%edx
 25a:	89 55 08             	mov    %edx,0x8(%ebp)
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f be c0             	movsbl %al,%eax
 263:	01 c8                	add    %ecx,%eax
 265:	83 e8 30             	sub    $0x30,%eax
 268:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	3c 2f                	cmp    $0x2f,%al
 273:	7e 0a                	jle    27f <atoi+0x48>
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	0f b6 00             	movzbl (%eax),%eax
 27b:	3c 39                	cmp    $0x39,%al
 27d:	7e c7                	jle    246 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 27f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 296:	eb 17                	jmp    2af <memmove+0x2b>
    *dst++ = *src++;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	8d 50 01             	lea    0x1(%eax),%edx
 29e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2a1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a7:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2aa:	0f b6 12             	movzbl (%edx),%edx
 2ad:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b5:	89 55 10             	mov    %edx,0x10(%ebp)
 2b8:	85 c0                	test   %eax,%eax
 2ba:	7f dc                	jg     298 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c1:	b8 01 00 00 00       	mov    $0x1,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exit>:
SYSCALL(exit)
 2c9:	b8 02 00 00 00       	mov    $0x2,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <wait>:
SYSCALL(wait)
 2d1:	b8 03 00 00 00       	mov    $0x3,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <pipe>:
SYSCALL(pipe)
 2d9:	b8 04 00 00 00       	mov    $0x4,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <read>:
SYSCALL(read)
 2e1:	b8 05 00 00 00       	mov    $0x5,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <write>:
SYSCALL(write)
 2e9:	b8 10 00 00 00       	mov    $0x10,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <close>:
SYSCALL(close)
 2f1:	b8 15 00 00 00       	mov    $0x15,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <kill>:
SYSCALL(kill)
 2f9:	b8 06 00 00 00       	mov    $0x6,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <exec>:
SYSCALL(exec)
 301:	b8 07 00 00 00       	mov    $0x7,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <open>:
SYSCALL(open)
 309:	b8 0f 00 00 00       	mov    $0xf,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <mknod>:
SYSCALL(mknod)
 311:	b8 11 00 00 00       	mov    $0x11,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <unlink>:
SYSCALL(unlink)
 319:	b8 12 00 00 00       	mov    $0x12,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <fstat>:
SYSCALL(fstat)
 321:	b8 08 00 00 00       	mov    $0x8,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <link>:
SYSCALL(link)
 329:	b8 13 00 00 00       	mov    $0x13,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <mkdir>:
SYSCALL(mkdir)
 331:	b8 14 00 00 00       	mov    $0x14,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <chdir>:
SYSCALL(chdir)
 339:	b8 09 00 00 00       	mov    $0x9,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <dup>:
SYSCALL(dup)
 341:	b8 0a 00 00 00       	mov    $0xa,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <getpid>:
SYSCALL(getpid)
 349:	b8 0b 00 00 00       	mov    $0xb,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <sbrk>:
SYSCALL(sbrk)
 351:	b8 0c 00 00 00       	mov    $0xc,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <sleep>:
SYSCALL(sleep)
 359:	b8 0d 00 00 00       	mov    $0xd,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <uptime>:
SYSCALL(uptime)
 361:	b8 0e 00 00 00       	mov    $0xe,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 18             	sub    $0x18,%esp
 36f:	8b 45 0c             	mov    0xc(%ebp),%eax
 372:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 375:	83 ec 04             	sub    $0x4,%esp
 378:	6a 01                	push   $0x1
 37a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 37d:	50                   	push   %eax
 37e:	ff 75 08             	pushl  0x8(%ebp)
 381:	e8 63 ff ff ff       	call   2e9 <write>
 386:	83 c4 10             	add    $0x10,%esp
}
 389:	c9                   	leave  
 38a:	c3                   	ret    

0000038b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38b:	55                   	push   %ebp
 38c:	89 e5                	mov    %esp,%ebp
 38e:	53                   	push   %ebx
 38f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 399:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 39d:	74 17                	je     3b6 <printint+0x2b>
 39f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3a3:	79 11                	jns    3b6 <printint+0x2b>
    neg = 1;
 3a5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 3af:	f7 d8                	neg    %eax
 3b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3b4:	eb 06                	jmp    3bc <printint+0x31>
  } else {
    x = xx;
 3b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3c3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c6:	8d 41 01             	lea    0x1(%ecx),%eax
 3c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3d2:	ba 00 00 00 00       	mov    $0x0,%edx
 3d7:	f7 f3                	div    %ebx
 3d9:	89 d0                	mov    %edx,%eax
 3db:	0f b6 80 6c 0a 00 00 	movzbl 0xa6c(%eax),%eax
 3e2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ec:	ba 00 00 00 00       	mov    $0x0,%edx
 3f1:	f7 f3                	div    %ebx
 3f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3fa:	75 c7                	jne    3c3 <printint+0x38>
  if(neg)
 3fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 400:	74 0e                	je     410 <printint+0x85>
    buf[i++] = '-';
 402:	8b 45 f4             	mov    -0xc(%ebp),%eax
 405:	8d 50 01             	lea    0x1(%eax),%edx
 408:	89 55 f4             	mov    %edx,-0xc(%ebp)
 40b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 410:	eb 1d                	jmp    42f <printint+0xa4>
    putc(fd, buf[i]);
 412:	8d 55 dc             	lea    -0x24(%ebp),%edx
 415:	8b 45 f4             	mov    -0xc(%ebp),%eax
 418:	01 d0                	add    %edx,%eax
 41a:	0f b6 00             	movzbl (%eax),%eax
 41d:	0f be c0             	movsbl %al,%eax
 420:	83 ec 08             	sub    $0x8,%esp
 423:	50                   	push   %eax
 424:	ff 75 08             	pushl  0x8(%ebp)
 427:	e8 3d ff ff ff       	call   369 <putc>
 42c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 42f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 433:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 437:	79 d9                	jns    412 <printint+0x87>
    putc(fd, buf[i]);
}
 439:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 43c:	c9                   	leave  
 43d:	c3                   	ret    

0000043e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 43e:	55                   	push   %ebp
 43f:	89 e5                	mov    %esp,%ebp
 441:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 444:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 44b:	8d 45 0c             	lea    0xc(%ebp),%eax
 44e:	83 c0 04             	add    $0x4,%eax
 451:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 454:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 45b:	e9 59 01 00 00       	jmp    5b9 <printf+0x17b>
    c = fmt[i] & 0xff;
 460:	8b 55 0c             	mov    0xc(%ebp),%edx
 463:	8b 45 f0             	mov    -0x10(%ebp),%eax
 466:	01 d0                	add    %edx,%eax
 468:	0f b6 00             	movzbl (%eax),%eax
 46b:	0f be c0             	movsbl %al,%eax
 46e:	25 ff 00 00 00       	and    $0xff,%eax
 473:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 476:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 47a:	75 2c                	jne    4a8 <printf+0x6a>
      if(c == '%'){
 47c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 480:	75 0c                	jne    48e <printf+0x50>
        state = '%';
 482:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 489:	e9 27 01 00 00       	jmp    5b5 <printf+0x177>
      } else {
        putc(fd, c);
 48e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 491:	0f be c0             	movsbl %al,%eax
 494:	83 ec 08             	sub    $0x8,%esp
 497:	50                   	push   %eax
 498:	ff 75 08             	pushl  0x8(%ebp)
 49b:	e8 c9 fe ff ff       	call   369 <putc>
 4a0:	83 c4 10             	add    $0x10,%esp
 4a3:	e9 0d 01 00 00       	jmp    5b5 <printf+0x177>
      }
    } else if(state == '%'){
 4a8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4ac:	0f 85 03 01 00 00    	jne    5b5 <printf+0x177>
      if(c == 'd'){
 4b2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b6:	75 1e                	jne    4d6 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bb:	8b 00                	mov    (%eax),%eax
 4bd:	6a 01                	push   $0x1
 4bf:	6a 0a                	push   $0xa
 4c1:	50                   	push   %eax
 4c2:	ff 75 08             	pushl  0x8(%ebp)
 4c5:	e8 c1 fe ff ff       	call   38b <printint>
 4ca:	83 c4 10             	add    $0x10,%esp
        ap++;
 4cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d1:	e9 d8 00 00 00       	jmp    5ae <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4d6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4da:	74 06                	je     4e2 <printf+0xa4>
 4dc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e0:	75 1e                	jne    500 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e5:	8b 00                	mov    (%eax),%eax
 4e7:	6a 00                	push   $0x0
 4e9:	6a 10                	push   $0x10
 4eb:	50                   	push   %eax
 4ec:	ff 75 08             	pushl  0x8(%ebp)
 4ef:	e8 97 fe ff ff       	call   38b <printint>
 4f4:	83 c4 10             	add    $0x10,%esp
        ap++;
 4f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4fb:	e9 ae 00 00 00       	jmp    5ae <printf+0x170>
      } else if(c == 's'){
 500:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 504:	75 43                	jne    549 <printf+0x10b>
        s = (char*)*ap;
 506:	8b 45 e8             	mov    -0x18(%ebp),%eax
 509:	8b 00                	mov    (%eax),%eax
 50b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 50e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 512:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 516:	75 07                	jne    51f <printf+0xe1>
          s = "(null)";
 518:	c7 45 f4 19 08 00 00 	movl   $0x819,-0xc(%ebp)
        while(*s != 0){
 51f:	eb 1c                	jmp    53d <printf+0xff>
          putc(fd, *s);
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	0f b6 00             	movzbl (%eax),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	83 ec 08             	sub    $0x8,%esp
 52d:	50                   	push   %eax
 52e:	ff 75 08             	pushl  0x8(%ebp)
 531:	e8 33 fe ff ff       	call   369 <putc>
 536:	83 c4 10             	add    $0x10,%esp
          s++;
 539:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 53d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	84 c0                	test   %al,%al
 545:	75 da                	jne    521 <printf+0xe3>
 547:	eb 65                	jmp    5ae <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 549:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 54d:	75 1d                	jne    56c <printf+0x12e>
        putc(fd, *ap);
 54f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 552:	8b 00                	mov    (%eax),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	83 ec 08             	sub    $0x8,%esp
 55a:	50                   	push   %eax
 55b:	ff 75 08             	pushl  0x8(%ebp)
 55e:	e8 06 fe ff ff       	call   369 <putc>
 563:	83 c4 10             	add    $0x10,%esp
        ap++;
 566:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56a:	eb 42                	jmp    5ae <printf+0x170>
      } else if(c == '%'){
 56c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 570:	75 17                	jne    589 <printf+0x14b>
        putc(fd, c);
 572:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	50                   	push   %eax
 57c:	ff 75 08             	pushl  0x8(%ebp)
 57f:	e8 e5 fd ff ff       	call   369 <putc>
 584:	83 c4 10             	add    $0x10,%esp
 587:	eb 25                	jmp    5ae <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 589:	83 ec 08             	sub    $0x8,%esp
 58c:	6a 25                	push   $0x25
 58e:	ff 75 08             	pushl  0x8(%ebp)
 591:	e8 d3 fd ff ff       	call   369 <putc>
 596:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 599:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 59c:	0f be c0             	movsbl %al,%eax
 59f:	83 ec 08             	sub    $0x8,%esp
 5a2:	50                   	push   %eax
 5a3:	ff 75 08             	pushl  0x8(%ebp)
 5a6:	e8 be fd ff ff       	call   369 <putc>
 5ab:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5b5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5bf:	01 d0                	add    %edx,%eax
 5c1:	0f b6 00             	movzbl (%eax),%eax
 5c4:	84 c0                	test   %al,%al
 5c6:	0f 85 94 fe ff ff    	jne    460 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5cc:	c9                   	leave  
 5cd:	c3                   	ret    

000005ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ce:	55                   	push   %ebp
 5cf:	89 e5                	mov    %esp,%ebp
 5d1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d4:	8b 45 08             	mov    0x8(%ebp),%eax
 5d7:	83 e8 08             	sub    $0x8,%eax
 5da:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5dd:	a1 88 0a 00 00       	mov    0xa88,%eax
 5e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e5:	eb 24                	jmp    60b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ea:	8b 00                	mov    (%eax),%eax
 5ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5ef:	77 12                	ja     603 <free+0x35>
 5f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5f7:	77 24                	ja     61d <free+0x4f>
 5f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 601:	77 1a                	ja     61d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 603:	8b 45 fc             	mov    -0x4(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	89 45 fc             	mov    %eax,-0x4(%ebp)
 60b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 611:	76 d4                	jbe    5e7 <free+0x19>
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61b:	76 ca                	jbe    5e7 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 61d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 620:	8b 40 04             	mov    0x4(%eax),%eax
 623:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 62a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62d:	01 c2                	add    %eax,%edx
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	39 c2                	cmp    %eax,%edx
 636:	75 24                	jne    65c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 638:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63b:	8b 50 04             	mov    0x4(%eax),%edx
 63e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	8b 40 04             	mov    0x4(%eax),%eax
 646:	01 c2                	add    %eax,%edx
 648:	8b 45 f8             	mov    -0x8(%ebp),%eax
 64b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 64e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	8b 10                	mov    (%eax),%edx
 655:	8b 45 f8             	mov    -0x8(%ebp),%eax
 658:	89 10                	mov    %edx,(%eax)
 65a:	eb 0a                	jmp    666 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 65c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65f:	8b 10                	mov    (%eax),%edx
 661:	8b 45 f8             	mov    -0x8(%ebp),%eax
 664:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 666:	8b 45 fc             	mov    -0x4(%ebp),%eax
 669:	8b 40 04             	mov    0x4(%eax),%eax
 66c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	01 d0                	add    %edx,%eax
 678:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67b:	75 20                	jne    69d <free+0xcf>
    p->s.size += bp->s.size;
 67d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 680:	8b 50 04             	mov    0x4(%eax),%edx
 683:	8b 45 f8             	mov    -0x8(%ebp),%eax
 686:	8b 40 04             	mov    0x4(%eax),%eax
 689:	01 c2                	add    %eax,%edx
 68b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 691:	8b 45 f8             	mov    -0x8(%ebp),%eax
 694:	8b 10                	mov    (%eax),%edx
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	89 10                	mov    %edx,(%eax)
 69b:	eb 08                	jmp    6a5 <free+0xd7>
  } else
    p->s.ptr = bp;
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6a3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	a3 88 0a 00 00       	mov    %eax,0xa88
}
 6ad:	c9                   	leave  
 6ae:	c3                   	ret    

000006af <morecore>:

static Header*
morecore(uint nu)
{
 6af:	55                   	push   %ebp
 6b0:	89 e5                	mov    %esp,%ebp
 6b2:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6b5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6bc:	77 07                	ja     6c5 <morecore+0x16>
    nu = 4096;
 6be:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	c1 e0 03             	shl    $0x3,%eax
 6cb:	83 ec 0c             	sub    $0xc,%esp
 6ce:	50                   	push   %eax
 6cf:	e8 7d fc ff ff       	call   351 <sbrk>
 6d4:	83 c4 10             	add    $0x10,%esp
 6d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6da:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6de:	75 07                	jne    6e7 <morecore+0x38>
    return 0;
 6e0:	b8 00 00 00 00       	mov    $0x0,%eax
 6e5:	eb 26                	jmp    70d <morecore+0x5e>
  hp = (Header*)p;
 6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f0:	8b 55 08             	mov    0x8(%ebp),%edx
 6f3:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f9:	83 c0 08             	add    $0x8,%eax
 6fc:	83 ec 0c             	sub    $0xc,%esp
 6ff:	50                   	push   %eax
 700:	e8 c9 fe ff ff       	call   5ce <free>
 705:	83 c4 10             	add    $0x10,%esp
  return freep;
 708:	a1 88 0a 00 00       	mov    0xa88,%eax
}
 70d:	c9                   	leave  
 70e:	c3                   	ret    

0000070f <malloc>:

void*
malloc(uint nbytes)
{
 70f:	55                   	push   %ebp
 710:	89 e5                	mov    %esp,%ebp
 712:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 715:	8b 45 08             	mov    0x8(%ebp),%eax
 718:	83 c0 07             	add    $0x7,%eax
 71b:	c1 e8 03             	shr    $0x3,%eax
 71e:	83 c0 01             	add    $0x1,%eax
 721:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 724:	a1 88 0a 00 00       	mov    0xa88,%eax
 729:	89 45 f0             	mov    %eax,-0x10(%ebp)
 72c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 730:	75 23                	jne    755 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 732:	c7 45 f0 80 0a 00 00 	movl   $0xa80,-0x10(%ebp)
 739:	8b 45 f0             	mov    -0x10(%ebp),%eax
 73c:	a3 88 0a 00 00       	mov    %eax,0xa88
 741:	a1 88 0a 00 00       	mov    0xa88,%eax
 746:	a3 80 0a 00 00       	mov    %eax,0xa80
    base.s.size = 0;
 74b:	c7 05 84 0a 00 00 00 	movl   $0x0,0xa84
 752:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 75d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 766:	72 4d                	jb     7b5 <malloc+0xa6>
      if(p->s.size == nunits)
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 40 04             	mov    0x4(%eax),%eax
 76e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 771:	75 0c                	jne    77f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	8b 10                	mov    (%eax),%edx
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	89 10                	mov    %edx,(%eax)
 77d:	eb 26                	jmp    7a5 <malloc+0x96>
      else {
        p->s.size -= nunits;
 77f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	2b 45 ec             	sub    -0x14(%ebp),%eax
 788:	89 c2                	mov    %eax,%edx
 78a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 790:	8b 45 f4             	mov    -0xc(%ebp),%eax
 793:	8b 40 04             	mov    0x4(%eax),%eax
 796:	c1 e0 03             	shl    $0x3,%eax
 799:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 79c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7a2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	a3 88 0a 00 00       	mov    %eax,0xa88
      return (void*)(p + 1);
 7ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b0:	83 c0 08             	add    $0x8,%eax
 7b3:	eb 3b                	jmp    7f0 <malloc+0xe1>
    }
    if(p == freep)
 7b5:	a1 88 0a 00 00       	mov    0xa88,%eax
 7ba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7bd:	75 1e                	jne    7dd <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7bf:	83 ec 0c             	sub    $0xc,%esp
 7c2:	ff 75 ec             	pushl  -0x14(%ebp)
 7c5:	e8 e5 fe ff ff       	call   6af <morecore>
 7ca:	83 c4 10             	add    $0x10,%esp
 7cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d4:	75 07                	jne    7dd <malloc+0xce>
        return 0;
 7d6:	b8 00 00 00 00       	mov    $0x0,%eax
 7db:	eb 13                	jmp    7f0 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7eb:	e9 6d ff ff ff       	jmp    75d <malloc+0x4e>
}
 7f0:	c9                   	leave  
 7f1:	c3                   	ret    
