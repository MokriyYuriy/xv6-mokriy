
_echo:     формат файла elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba e3 07 00 00       	mov    $0x7e3,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba e5 07 00 00       	mov    $0x7e5,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 e7 07 00 00       	push   $0x7e7
  4b:	6a 01                	push   $0x1
  4d:	e8 dd 03 00 00       	call   42f <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 55 02 00 00       	call   2ba <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	5b                   	pop    %ebx
  87:	5f                   	pop    %edi
  88:	5d                   	pop    %ebp
  89:	c3                   	ret    

0000008a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8a:	55                   	push   %ebp
  8b:	89 e5                	mov    %esp,%ebp
  8d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  90:	8b 45 08             	mov    0x8(%ebp),%eax
  93:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  96:	90                   	nop
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	8d 50 01             	lea    0x1(%eax),%edx
  9d:	89 55 08             	mov    %edx,0x8(%ebp)
  a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  a6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  a9:	0f b6 12             	movzbl (%edx),%edx
  ac:	88 10                	mov    %dl,(%eax)
  ae:	0f b6 00             	movzbl (%eax),%eax
  b1:	84 c0                	test   %al,%al
  b3:	75 e2                	jne    97 <strcpy+0xd>
    ;
  return os;
  b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b8:	c9                   	leave  
  b9:	c3                   	ret    

000000ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ba:	55                   	push   %ebp
  bb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  bd:	eb 08                	jmp    c7 <strcmp+0xd>
    p++, q++;
  bf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c7:	8b 45 08             	mov    0x8(%ebp),%eax
  ca:	0f b6 00             	movzbl (%eax),%eax
  cd:	84 c0                	test   %al,%al
  cf:	74 10                	je     e1 <strcmp+0x27>
  d1:	8b 45 08             	mov    0x8(%ebp),%eax
  d4:	0f b6 10             	movzbl (%eax),%edx
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	38 c2                	cmp    %al,%dl
  df:	74 de                	je     bf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 00             	movzbl (%eax),%eax
  e7:	0f b6 d0             	movzbl %al,%edx
  ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  ed:	0f b6 00             	movzbl (%eax),%eax
  f0:	0f b6 c0             	movzbl %al,%eax
  f3:	29 c2                	sub    %eax,%edx
  f5:	89 d0                	mov    %edx,%eax
}
  f7:	5d                   	pop    %ebp
  f8:	c3                   	ret    

000000f9 <strlen>:

uint
strlen(char *s)
{
  f9:	55                   	push   %ebp
  fa:	89 e5                	mov    %esp,%ebp
  fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 106:	eb 04                	jmp    10c <strlen+0x13>
 108:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	01 d0                	add    %edx,%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	84 c0                	test   %al,%al
 119:	75 ed                	jne    108 <strlen+0xf>
    ;
  return n;
 11b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11e:	c9                   	leave  
 11f:	c3                   	ret    

00000120 <memset>:

void*
memset(void *dst, int c, uint n)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 123:	8b 45 10             	mov    0x10(%ebp),%eax
 126:	50                   	push   %eax
 127:	ff 75 0c             	pushl  0xc(%ebp)
 12a:	ff 75 08             	pushl  0x8(%ebp)
 12d:	e8 33 ff ff ff       	call   65 <stosb>
 132:	83 c4 0c             	add    $0xc,%esp
  return dst;
 135:	8b 45 08             	mov    0x8(%ebp),%eax
}
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <strchr>:

char*
strchr(const char *s, char c)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	83 ec 04             	sub    $0x4,%esp
 140:	8b 45 0c             	mov    0xc(%ebp),%eax
 143:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 146:	eb 14                	jmp    15c <strchr+0x22>
    if(*s == c)
 148:	8b 45 08             	mov    0x8(%ebp),%eax
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 151:	75 05                	jne    158 <strchr+0x1e>
      return (char*)s;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	eb 13                	jmp    16b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 158:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	0f b6 00             	movzbl (%eax),%eax
 162:	84 c0                	test   %al,%al
 164:	75 e2                	jne    148 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 166:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16b:	c9                   	leave  
 16c:	c3                   	ret    

0000016d <gets>:

char*
gets(char *buf, int max)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
 170:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 173:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17a:	eb 44                	jmp    1c0 <gets+0x53>
    cc = read(0, &c, 1);
 17c:	83 ec 04             	sub    $0x4,%esp
 17f:	6a 01                	push   $0x1
 181:	8d 45 ef             	lea    -0x11(%ebp),%eax
 184:	50                   	push   %eax
 185:	6a 00                	push   $0x0
 187:	e8 46 01 00 00       	call   2d2 <read>
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 192:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 196:	7f 02                	jg     19a <gets+0x2d>
      break;
 198:	eb 31                	jmp    1cb <gets+0x5e>
    buf[i++] = c;
 19a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19d:	8d 50 01             	lea    0x1(%eax),%edx
 1a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a3:	89 c2                	mov    %eax,%edx
 1a5:	8b 45 08             	mov    0x8(%ebp),%eax
 1a8:	01 c2                	add    %eax,%edx
 1aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ae:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b4:	3c 0a                	cmp    $0xa,%al
 1b6:	74 13                	je     1cb <gets+0x5e>
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	3c 0d                	cmp    $0xd,%al
 1be:	74 0b                	je     1cb <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c3:	83 c0 01             	add    $0x1,%eax
 1c6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c9:	7c b1                	jl     17c <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
 1d3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d9:	c9                   	leave  
 1da:	c3                   	ret    

000001db <stat>:

int
stat(char *n, struct stat *st)
{
 1db:	55                   	push   %ebp
 1dc:	89 e5                	mov    %esp,%ebp
 1de:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e1:	83 ec 08             	sub    $0x8,%esp
 1e4:	6a 00                	push   $0x0
 1e6:	ff 75 08             	pushl  0x8(%ebp)
 1e9:	e8 0c 01 00 00       	call   2fa <open>
 1ee:	83 c4 10             	add    $0x10,%esp
 1f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f8:	79 07                	jns    201 <stat+0x26>
    return -1;
 1fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1ff:	eb 25                	jmp    226 <stat+0x4b>
  r = fstat(fd, st);
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 f4             	pushl  -0xc(%ebp)
 20a:	e8 03 01 00 00       	call   312 <fstat>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 215:	83 ec 0c             	sub    $0xc,%esp
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 c2 00 00 00       	call   2e2 <close>
 220:	83 c4 10             	add    $0x10,%esp
  return r;
 223:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <atoi>:

int
atoi(const char *s)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 22e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 235:	eb 25                	jmp    25c <atoi+0x34>
    n = n*10 + *s++ - '0';
 237:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23a:	89 d0                	mov    %edx,%eax
 23c:	c1 e0 02             	shl    $0x2,%eax
 23f:	01 d0                	add    %edx,%eax
 241:	01 c0                	add    %eax,%eax
 243:	89 c1                	mov    %eax,%ecx
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	8d 50 01             	lea    0x1(%eax),%edx
 24b:	89 55 08             	mov    %edx,0x8(%ebp)
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	0f be c0             	movsbl %al,%eax
 254:	01 c8                	add    %ecx,%eax
 256:	83 e8 30             	sub    $0x30,%eax
 259:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	3c 2f                	cmp    $0x2f,%al
 264:	7e 0a                	jle    270 <atoi+0x48>
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	3c 39                	cmp    $0x39,%al
 26e:	7e c7                	jle    237 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 281:	8b 45 0c             	mov    0xc(%ebp),%eax
 284:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 287:	eb 17                	jmp    2a0 <memmove+0x2b>
    *dst++ = *src++;
 289:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28c:	8d 50 01             	lea    0x1(%eax),%edx
 28f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 292:	8b 55 f8             	mov    -0x8(%ebp),%edx
 295:	8d 4a 01             	lea    0x1(%edx),%ecx
 298:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29b:	0f b6 12             	movzbl (%edx),%edx
 29e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a0:	8b 45 10             	mov    0x10(%ebp),%eax
 2a3:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a6:	89 55 10             	mov    %edx,0x10(%ebp)
 2a9:	85 c0                	test   %eax,%eax
 2ab:	7f dc                	jg     289 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b2:	b8 01 00 00 00       	mov    $0x1,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <exit>:
SYSCALL(exit)
 2ba:	b8 02 00 00 00       	mov    $0x2,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <wait>:
SYSCALL(wait)
 2c2:	b8 03 00 00 00       	mov    $0x3,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <pipe>:
SYSCALL(pipe)
 2ca:	b8 04 00 00 00       	mov    $0x4,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <read>:
SYSCALL(read)
 2d2:	b8 05 00 00 00       	mov    $0x5,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <write>:
SYSCALL(write)
 2da:	b8 10 00 00 00       	mov    $0x10,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <close>:
SYSCALL(close)
 2e2:	b8 15 00 00 00       	mov    $0x15,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <kill>:
SYSCALL(kill)
 2ea:	b8 06 00 00 00       	mov    $0x6,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <exec>:
SYSCALL(exec)
 2f2:	b8 07 00 00 00       	mov    $0x7,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <open>:
SYSCALL(open)
 2fa:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <mknod>:
SYSCALL(mknod)
 302:	b8 11 00 00 00       	mov    $0x11,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <unlink>:
SYSCALL(unlink)
 30a:	b8 12 00 00 00       	mov    $0x12,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <fstat>:
SYSCALL(fstat)
 312:	b8 08 00 00 00       	mov    $0x8,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <link>:
SYSCALL(link)
 31a:	b8 13 00 00 00       	mov    $0x13,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <mkdir>:
SYSCALL(mkdir)
 322:	b8 14 00 00 00       	mov    $0x14,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <chdir>:
SYSCALL(chdir)
 32a:	b8 09 00 00 00       	mov    $0x9,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <dup>:
SYSCALL(dup)
 332:	b8 0a 00 00 00       	mov    $0xa,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <getpid>:
SYSCALL(getpid)
 33a:	b8 0b 00 00 00       	mov    $0xb,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sbrk>:
SYSCALL(sbrk)
 342:	b8 0c 00 00 00       	mov    $0xc,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sleep>:
SYSCALL(sleep)
 34a:	b8 0d 00 00 00       	mov    $0xd,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <uptime>:
SYSCALL(uptime)
 352:	b8 0e 00 00 00       	mov    $0xe,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 18             	sub    $0x18,%esp
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 366:	83 ec 04             	sub    $0x4,%esp
 369:	6a 01                	push   $0x1
 36b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 36e:	50                   	push   %eax
 36f:	ff 75 08             	pushl  0x8(%ebp)
 372:	e8 63 ff ff ff       	call   2da <write>
 377:	83 c4 10             	add    $0x10,%esp
}
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	53                   	push   %ebx
 380:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 383:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 38a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 38e:	74 17                	je     3a7 <printint+0x2b>
 390:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 394:	79 11                	jns    3a7 <printint+0x2b>
    neg = 1;
 396:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	f7 d8                	neg    %eax
 3a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3a5:	eb 06                	jmp    3ad <printint+0x31>
  } else {
    x = xx;
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3b4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3b7:	8d 41 01             	lea    0x1(%ecx),%eax
 3ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3bd:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c3:	ba 00 00 00 00       	mov    $0x0,%edx
 3c8:	f7 f3                	div    %ebx
 3ca:	89 d0                	mov    %edx,%eax
 3cc:	0f b6 80 40 0a 00 00 	movzbl 0xa40(%eax),%eax
 3d3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3dd:	ba 00 00 00 00       	mov    $0x0,%edx
 3e2:	f7 f3                	div    %ebx
 3e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3eb:	75 c7                	jne    3b4 <printint+0x38>
  if(neg)
 3ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f1:	74 0e                	je     401 <printint+0x85>
    buf[i++] = '-';
 3f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f6:	8d 50 01             	lea    0x1(%eax),%edx
 3f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3fc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 401:	eb 1d                	jmp    420 <printint+0xa4>
    putc(fd, buf[i]);
 403:	8d 55 dc             	lea    -0x24(%ebp),%edx
 406:	8b 45 f4             	mov    -0xc(%ebp),%eax
 409:	01 d0                	add    %edx,%eax
 40b:	0f b6 00             	movzbl (%eax),%eax
 40e:	0f be c0             	movsbl %al,%eax
 411:	83 ec 08             	sub    $0x8,%esp
 414:	50                   	push   %eax
 415:	ff 75 08             	pushl  0x8(%ebp)
 418:	e8 3d ff ff ff       	call   35a <putc>
 41d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 420:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 424:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 428:	79 d9                	jns    403 <printint+0x87>
    putc(fd, buf[i]);
}
 42a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 42d:	c9                   	leave  
 42e:	c3                   	ret    

0000042f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 42f:	55                   	push   %ebp
 430:	89 e5                	mov    %esp,%ebp
 432:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 43c:	8d 45 0c             	lea    0xc(%ebp),%eax
 43f:	83 c0 04             	add    $0x4,%eax
 442:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 445:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 44c:	e9 59 01 00 00       	jmp    5aa <printf+0x17b>
    c = fmt[i] & 0xff;
 451:	8b 55 0c             	mov    0xc(%ebp),%edx
 454:	8b 45 f0             	mov    -0x10(%ebp),%eax
 457:	01 d0                	add    %edx,%eax
 459:	0f b6 00             	movzbl (%eax),%eax
 45c:	0f be c0             	movsbl %al,%eax
 45f:	25 ff 00 00 00       	and    $0xff,%eax
 464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 467:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46b:	75 2c                	jne    499 <printf+0x6a>
      if(c == '%'){
 46d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 471:	75 0c                	jne    47f <printf+0x50>
        state = '%';
 473:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47a:	e9 27 01 00 00       	jmp    5a6 <printf+0x177>
      } else {
        putc(fd, c);
 47f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 482:	0f be c0             	movsbl %al,%eax
 485:	83 ec 08             	sub    $0x8,%esp
 488:	50                   	push   %eax
 489:	ff 75 08             	pushl  0x8(%ebp)
 48c:	e8 c9 fe ff ff       	call   35a <putc>
 491:	83 c4 10             	add    $0x10,%esp
 494:	e9 0d 01 00 00       	jmp    5a6 <printf+0x177>
      }
    } else if(state == '%'){
 499:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 49d:	0f 85 03 01 00 00    	jne    5a6 <printf+0x177>
      if(c == 'd'){
 4a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4a7:	75 1e                	jne    4c7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ac:	8b 00                	mov    (%eax),%eax
 4ae:	6a 01                	push   $0x1
 4b0:	6a 0a                	push   $0xa
 4b2:	50                   	push   %eax
 4b3:	ff 75 08             	pushl  0x8(%ebp)
 4b6:	e8 c1 fe ff ff       	call   37c <printint>
 4bb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4c2:	e9 d8 00 00 00       	jmp    59f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4c7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4cb:	74 06                	je     4d3 <printf+0xa4>
 4cd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4d1:	75 1e                	jne    4f1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d6:	8b 00                	mov    (%eax),%eax
 4d8:	6a 00                	push   $0x0
 4da:	6a 10                	push   $0x10
 4dc:	50                   	push   %eax
 4dd:	ff 75 08             	pushl  0x8(%ebp)
 4e0:	e8 97 fe ff ff       	call   37c <printint>
 4e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ec:	e9 ae 00 00 00       	jmp    59f <printf+0x170>
      } else if(c == 's'){
 4f1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4f5:	75 43                	jne    53a <printf+0x10b>
        s = (char*)*ap;
 4f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4fa:	8b 00                	mov    (%eax),%eax
 4fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 507:	75 07                	jne    510 <printf+0xe1>
          s = "(null)";
 509:	c7 45 f4 ec 07 00 00 	movl   $0x7ec,-0xc(%ebp)
        while(*s != 0){
 510:	eb 1c                	jmp    52e <printf+0xff>
          putc(fd, *s);
 512:	8b 45 f4             	mov    -0xc(%ebp),%eax
 515:	0f b6 00             	movzbl (%eax),%eax
 518:	0f be c0             	movsbl %al,%eax
 51b:	83 ec 08             	sub    $0x8,%esp
 51e:	50                   	push   %eax
 51f:	ff 75 08             	pushl  0x8(%ebp)
 522:	e8 33 fe ff ff       	call   35a <putc>
 527:	83 c4 10             	add    $0x10,%esp
          s++;
 52a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 531:	0f b6 00             	movzbl (%eax),%eax
 534:	84 c0                	test   %al,%al
 536:	75 da                	jne    512 <printf+0xe3>
 538:	eb 65                	jmp    59f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 53a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 53e:	75 1d                	jne    55d <printf+0x12e>
        putc(fd, *ap);
 540:	8b 45 e8             	mov    -0x18(%ebp),%eax
 543:	8b 00                	mov    (%eax),%eax
 545:	0f be c0             	movsbl %al,%eax
 548:	83 ec 08             	sub    $0x8,%esp
 54b:	50                   	push   %eax
 54c:	ff 75 08             	pushl  0x8(%ebp)
 54f:	e8 06 fe ff ff       	call   35a <putc>
 554:	83 c4 10             	add    $0x10,%esp
        ap++;
 557:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55b:	eb 42                	jmp    59f <printf+0x170>
      } else if(c == '%'){
 55d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 561:	75 17                	jne    57a <printf+0x14b>
        putc(fd, c);
 563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 566:	0f be c0             	movsbl %al,%eax
 569:	83 ec 08             	sub    $0x8,%esp
 56c:	50                   	push   %eax
 56d:	ff 75 08             	pushl  0x8(%ebp)
 570:	e8 e5 fd ff ff       	call   35a <putc>
 575:	83 c4 10             	add    $0x10,%esp
 578:	eb 25                	jmp    59f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 57a:	83 ec 08             	sub    $0x8,%esp
 57d:	6a 25                	push   $0x25
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 d3 fd ff ff       	call   35a <putc>
 587:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 58a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 ec 08             	sub    $0x8,%esp
 593:	50                   	push   %eax
 594:	ff 75 08             	pushl  0x8(%ebp)
 597:	e8 be fd ff ff       	call   35a <putc>
 59c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 59f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b0:	01 d0                	add    %edx,%eax
 5b2:	0f b6 00             	movzbl (%eax),%eax
 5b5:	84 c0                	test   %al,%al
 5b7:	0f 85 94 fe ff ff    	jne    451 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5bd:	c9                   	leave  
 5be:	c3                   	ret    

000005bf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5bf:	55                   	push   %ebp
 5c0:	89 e5                	mov    %esp,%ebp
 5c2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5c5:	8b 45 08             	mov    0x8(%ebp),%eax
 5c8:	83 e8 08             	sub    $0x8,%eax
 5cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ce:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 5d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5d6:	eb 24                	jmp    5fc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5db:	8b 00                	mov    (%eax),%eax
 5dd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e0:	77 12                	ja     5f4 <free+0x35>
 5e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e8:	77 24                	ja     60e <free+0x4f>
 5ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f2:	77 1a                	ja     60e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f7:	8b 00                	mov    (%eax),%eax
 5f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 602:	76 d4                	jbe    5d8 <free+0x19>
 604:	8b 45 fc             	mov    -0x4(%ebp),%eax
 607:	8b 00                	mov    (%eax),%eax
 609:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 60c:	76 ca                	jbe    5d8 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	8b 40 04             	mov    0x4(%eax),%eax
 614:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 61b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 61e:	01 c2                	add    %eax,%edx
 620:	8b 45 fc             	mov    -0x4(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	39 c2                	cmp    %eax,%edx
 627:	75 24                	jne    64d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 629:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62c:	8b 50 04             	mov    0x4(%eax),%edx
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	8b 40 04             	mov    0x4(%eax),%eax
 637:	01 c2                	add    %eax,%edx
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8b 00                	mov    (%eax),%eax
 644:	8b 10                	mov    (%eax),%edx
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	89 10                	mov    %edx,(%eax)
 64b:	eb 0a                	jmp    657 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 64d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 650:	8b 10                	mov    (%eax),%edx
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 657:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65a:	8b 40 04             	mov    0x4(%eax),%eax
 65d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	01 d0                	add    %edx,%eax
 669:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 66c:	75 20                	jne    68e <free+0xcf>
    p->s.size += bp->s.size;
 66e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 671:	8b 50 04             	mov    0x4(%eax),%edx
 674:	8b 45 f8             	mov    -0x8(%ebp),%eax
 677:	8b 40 04             	mov    0x4(%eax),%eax
 67a:	01 c2                	add    %eax,%edx
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 682:	8b 45 f8             	mov    -0x8(%ebp),%eax
 685:	8b 10                	mov    (%eax),%edx
 687:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68a:	89 10                	mov    %edx,(%eax)
 68c:	eb 08                	jmp    696 <free+0xd7>
  } else
    p->s.ptr = bp;
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 55 f8             	mov    -0x8(%ebp),%edx
 694:	89 10                	mov    %edx,(%eax)
  freep = p;
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	a3 5c 0a 00 00       	mov    %eax,0xa5c
}
 69e:	c9                   	leave  
 69f:	c3                   	ret    

000006a0 <morecore>:

static Header*
morecore(uint nu)
{
 6a0:	55                   	push   %ebp
 6a1:	89 e5                	mov    %esp,%ebp
 6a3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6a6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6ad:	77 07                	ja     6b6 <morecore+0x16>
    nu = 4096;
 6af:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	c1 e0 03             	shl    $0x3,%eax
 6bc:	83 ec 0c             	sub    $0xc,%esp
 6bf:	50                   	push   %eax
 6c0:	e8 7d fc ff ff       	call   342 <sbrk>
 6c5:	83 c4 10             	add    $0x10,%esp
 6c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6cb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6cf:	75 07                	jne    6d8 <morecore+0x38>
    return 0;
 6d1:	b8 00 00 00 00       	mov    $0x0,%eax
 6d6:	eb 26                	jmp    6fe <morecore+0x5e>
  hp = (Header*)p;
 6d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e1:	8b 55 08             	mov    0x8(%ebp),%edx
 6e4:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ea:	83 c0 08             	add    $0x8,%eax
 6ed:	83 ec 0c             	sub    $0xc,%esp
 6f0:	50                   	push   %eax
 6f1:	e8 c9 fe ff ff       	call   5bf <free>
 6f6:	83 c4 10             	add    $0x10,%esp
  return freep;
 6f9:	a1 5c 0a 00 00       	mov    0xa5c,%eax
}
 6fe:	c9                   	leave  
 6ff:	c3                   	ret    

00000700 <malloc>:

void*
malloc(uint nbytes)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 706:	8b 45 08             	mov    0x8(%ebp),%eax
 709:	83 c0 07             	add    $0x7,%eax
 70c:	c1 e8 03             	shr    $0x3,%eax
 70f:	83 c0 01             	add    $0x1,%eax
 712:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 715:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 71a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 71d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 721:	75 23                	jne    746 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 723:	c7 45 f0 54 0a 00 00 	movl   $0xa54,-0x10(%ebp)
 72a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 72d:	a3 5c 0a 00 00       	mov    %eax,0xa5c
 732:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 737:	a3 54 0a 00 00       	mov    %eax,0xa54
    base.s.size = 0;
 73c:	c7 05 58 0a 00 00 00 	movl   $0x0,0xa58
 743:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 746:	8b 45 f0             	mov    -0x10(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	8b 40 04             	mov    0x4(%eax),%eax
 754:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 757:	72 4d                	jb     7a6 <malloc+0xa6>
      if(p->s.size == nunits)
 759:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75c:	8b 40 04             	mov    0x4(%eax),%eax
 75f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 762:	75 0c                	jne    770 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 764:	8b 45 f4             	mov    -0xc(%ebp),%eax
 767:	8b 10                	mov    (%eax),%edx
 769:	8b 45 f0             	mov    -0x10(%ebp),%eax
 76c:	89 10                	mov    %edx,(%eax)
 76e:	eb 26                	jmp    796 <malloc+0x96>
      else {
        p->s.size -= nunits;
 770:	8b 45 f4             	mov    -0xc(%ebp),%eax
 773:	8b 40 04             	mov    0x4(%eax),%eax
 776:	2b 45 ec             	sub    -0x14(%ebp),%eax
 779:	89 c2                	mov    %eax,%edx
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	c1 e0 03             	shl    $0x3,%eax
 78a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	8b 55 ec             	mov    -0x14(%ebp),%edx
 793:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
 799:	a3 5c 0a 00 00       	mov    %eax,0xa5c
      return (void*)(p + 1);
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	83 c0 08             	add    $0x8,%eax
 7a4:	eb 3b                	jmp    7e1 <malloc+0xe1>
    }
    if(p == freep)
 7a6:	a1 5c 0a 00 00       	mov    0xa5c,%eax
 7ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7ae:	75 1e                	jne    7ce <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7b0:	83 ec 0c             	sub    $0xc,%esp
 7b3:	ff 75 ec             	pushl  -0x14(%ebp)
 7b6:	e8 e5 fe ff ff       	call   6a0 <morecore>
 7bb:	83 c4 10             	add    $0x10,%esp
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c5:	75 07                	jne    7ce <malloc+0xce>
        return 0;
 7c7:	b8 00 00 00 00       	mov    $0x0,%eax
 7cc:	eb 13                	jmp    7e1 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7dc:	e9 6d ff ff ff       	jmp    74e <malloc+0x4e>
}
 7e1:	c9                   	leave  
 7e2:	c3                   	ret    
