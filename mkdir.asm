
_mkdir:     формат файла elf32-i386


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

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: mkdir files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 0e 08 00 00       	push   $0x80e
  21:	6a 02                	push   $0x2
  23:	e8 32 04 00 00       	call   45a <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 b5 02 00 00       	call   2e5 <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(mkdir(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 fa 02 00 00       	call   34d <mkdir>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 25 08 00 00       	push   $0x825
  74:	6a 02                	push   $0x2
  76:	e8 df 03 00 00       	call   45a <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  8b:	e8 55 02 00 00       	call   2e5 <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8d 50 01             	lea    0x1(%eax),%edx
  c8:	89 55 08             	mov    %edx,0x8(%ebp)
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d4:	0f b6 12             	movzbl (%edx),%edx
  d7:	88 10                	mov    %dl,(%eax)
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	75 e2                	jne    c2 <strcpy+0xd>
    ;
  return os;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e8:	eb 08                	jmp    f2 <strcmp+0xd>
    p++, q++;
  ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	84 c0                	test   %al,%al
  fa:	74 10                	je     10c <strcmp+0x27>
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	38 c2                	cmp    %al,%dl
 10a:	74 de                	je     ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 d0             	movzbl %al,%edx
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	0f b6 c0             	movzbl %al,%eax
 11e:	29 c2                	sub    %eax,%edx
 120:	89 d0                	mov    %edx,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strlen>:

uint
strlen(char *s)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 131:	eb 04                	jmp    137 <strlen+0x13>
 133:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 137:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	01 d0                	add    %edx,%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 ed                	jne    133 <strlen+0xf>
    ;
  return n;
 146:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <memset>:

void*
memset(void *dst, int c, uint n)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14e:	8b 45 10             	mov    0x10(%ebp),%eax
 151:	50                   	push   %eax
 152:	ff 75 0c             	pushl  0xc(%ebp)
 155:	ff 75 08             	pushl  0x8(%ebp)
 158:	e8 33 ff ff ff       	call   90 <stosb>
 15d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strchr>:

char*
strchr(const char *s, char c)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 171:	eb 14                	jmp    187 <strchr+0x22>
    if(*s == c)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17c:	75 05                	jne    183 <strchr+0x1e>
      return (char*)s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	eb 13                	jmp    196 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 183:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 e2                	jne    173 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a5:	eb 44                	jmp    1eb <gets+0x53>
    cc = read(0, &c, 1);
 1a7:	83 ec 04             	sub    $0x4,%esp
 1aa:	6a 01                	push   $0x1
 1ac:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1af:	50                   	push   %eax
 1b0:	6a 00                	push   $0x0
 1b2:	e8 46 01 00 00       	call   2fd <read>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c1:	7f 02                	jg     1c5 <gets+0x2d>
      break;
 1c3:	eb 31                	jmp    1f6 <gets+0x5e>
    buf[i++] = c;
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	8d 50 01             	lea    0x1(%eax),%edx
 1cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ce:	89 c2                	mov    %eax,%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 c2                	add    %eax,%edx
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1db:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1df:	3c 0a                	cmp    $0xa,%al
 1e1:	74 13                	je     1f6 <gets+0x5e>
 1e3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e7:	3c 0d                	cmp    $0xd,%al
 1e9:	74 0b                	je     1f6 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ee:	83 c0 01             	add    $0x1,%eax
 1f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f4:	7c b1                	jl     1a7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	01 d0                	add    %edx,%eax
 1fe:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
}
 204:	c9                   	leave  
 205:	c3                   	ret    

00000206 <stat>:

int
stat(char *n, struct stat *st)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20c:	83 ec 08             	sub    $0x8,%esp
 20f:	6a 00                	push   $0x0
 211:	ff 75 08             	pushl  0x8(%ebp)
 214:	e8 0c 01 00 00       	call   325 <open>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 223:	79 07                	jns    22c <stat+0x26>
    return -1;
 225:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22a:	eb 25                	jmp    251 <stat+0x4b>
  r = fstat(fd, st);
 22c:	83 ec 08             	sub    $0x8,%esp
 22f:	ff 75 0c             	pushl  0xc(%ebp)
 232:	ff 75 f4             	pushl  -0xc(%ebp)
 235:	e8 03 01 00 00       	call   33d <fstat>
 23a:	83 c4 10             	add    $0x10,%esp
 23d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 240:	83 ec 0c             	sub    $0xc,%esp
 243:	ff 75 f4             	pushl  -0xc(%ebp)
 246:	e8 c2 00 00 00       	call   30d <close>
 24b:	83 c4 10             	add    $0x10,%esp
  return r;
 24e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 251:	c9                   	leave  
 252:	c3                   	ret    

00000253 <atoi>:

int
atoi(const char *s)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 260:	eb 25                	jmp    287 <atoi+0x34>
    n = n*10 + *s++ - '0';
 262:	8b 55 fc             	mov    -0x4(%ebp),%edx
 265:	89 d0                	mov    %edx,%eax
 267:	c1 e0 02             	shl    $0x2,%eax
 26a:	01 d0                	add    %edx,%eax
 26c:	01 c0                	add    %eax,%eax
 26e:	89 c1                	mov    %eax,%ecx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	8d 50 01             	lea    0x1(%eax),%edx
 276:	89 55 08             	mov    %edx,0x8(%ebp)
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	0f be c0             	movsbl %al,%eax
 27f:	01 c8                	add    %ecx,%eax
 281:	83 e8 30             	sub    $0x30,%eax
 284:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	3c 2f                	cmp    $0x2f,%al
 28f:	7e 0a                	jle    29b <atoi+0x48>
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	0f b6 00             	movzbl (%eax),%eax
 297:	3c 39                	cmp    $0x39,%al
 299:	7e c7                	jle    262 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 29b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29e:	c9                   	leave  
 29f:	c3                   	ret    

000002a0 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 2af:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2b2:	eb 17                	jmp    2cb <memmove+0x2b>
    *dst++ = *src++;
 2b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b7:	8d 50 01             	lea    0x1(%eax),%edx
 2ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c0:	8d 4a 01             	lea    0x1(%edx),%ecx
 2c3:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2c6:	0f b6 12             	movzbl (%edx),%edx
 2c9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2cb:	8b 45 10             	mov    0x10(%ebp),%eax
 2ce:	8d 50 ff             	lea    -0x1(%eax),%edx
 2d1:	89 55 10             	mov    %edx,0x10(%ebp)
 2d4:	85 c0                	test   %eax,%eax
 2d6:	7f dc                	jg     2b4 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2db:	c9                   	leave  
 2dc:	c3                   	ret    

000002dd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2dd:	b8 01 00 00 00       	mov    $0x1,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <exit>:
SYSCALL(exit)
 2e5:	b8 02 00 00 00       	mov    $0x2,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <wait>:
SYSCALL(wait)
 2ed:	b8 03 00 00 00       	mov    $0x3,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <pipe>:
SYSCALL(pipe)
 2f5:	b8 04 00 00 00       	mov    $0x4,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <read>:
SYSCALL(read)
 2fd:	b8 05 00 00 00       	mov    $0x5,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <write>:
SYSCALL(write)
 305:	b8 10 00 00 00       	mov    $0x10,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <close>:
SYSCALL(close)
 30d:	b8 15 00 00 00       	mov    $0x15,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <kill>:
SYSCALL(kill)
 315:	b8 06 00 00 00       	mov    $0x6,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <exec>:
SYSCALL(exec)
 31d:	b8 07 00 00 00       	mov    $0x7,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <open>:
SYSCALL(open)
 325:	b8 0f 00 00 00       	mov    $0xf,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <mknod>:
SYSCALL(mknod)
 32d:	b8 11 00 00 00       	mov    $0x11,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <unlink>:
SYSCALL(unlink)
 335:	b8 12 00 00 00       	mov    $0x12,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <fstat>:
SYSCALL(fstat)
 33d:	b8 08 00 00 00       	mov    $0x8,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <link>:
SYSCALL(link)
 345:	b8 13 00 00 00       	mov    $0x13,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <mkdir>:
SYSCALL(mkdir)
 34d:	b8 14 00 00 00       	mov    $0x14,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <chdir>:
SYSCALL(chdir)
 355:	b8 09 00 00 00       	mov    $0x9,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <dup>:
SYSCALL(dup)
 35d:	b8 0a 00 00 00       	mov    $0xa,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <getpid>:
SYSCALL(getpid)
 365:	b8 0b 00 00 00       	mov    $0xb,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <sbrk>:
SYSCALL(sbrk)
 36d:	b8 0c 00 00 00       	mov    $0xc,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <sleep>:
SYSCALL(sleep)
 375:	b8 0d 00 00 00       	mov    $0xd,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <uptime>:
SYSCALL(uptime)
 37d:	b8 0e 00 00 00       	mov    $0xe,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	83 ec 18             	sub    $0x18,%esp
 38b:	8b 45 0c             	mov    0xc(%ebp),%eax
 38e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 391:	83 ec 04             	sub    $0x4,%esp
 394:	6a 01                	push   $0x1
 396:	8d 45 f4             	lea    -0xc(%ebp),%eax
 399:	50                   	push   %eax
 39a:	ff 75 08             	pushl  0x8(%ebp)
 39d:	e8 63 ff ff ff       	call   305 <write>
 3a2:	83 c4 10             	add    $0x10,%esp
}
 3a5:	c9                   	leave  
 3a6:	c3                   	ret    

000003a7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
 3aa:	53                   	push   %ebx
 3ab:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3b5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3b9:	74 17                	je     3d2 <printint+0x2b>
 3bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3bf:	79 11                	jns    3d2 <printint+0x2b>
    neg = 1;
 3c1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	f7 d8                	neg    %eax
 3cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d0:	eb 06                	jmp    3d8 <printint+0x31>
  } else {
    x = xx;
 3d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3df:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3e2:	8d 41 01             	lea    0x1(%ecx),%eax
 3e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3ee:	ba 00 00 00 00       	mov    $0x0,%edx
 3f3:	f7 f3                	div    %ebx
 3f5:	89 d0                	mov    %edx,%eax
 3f7:	0f b6 80 94 0a 00 00 	movzbl 0xa94(%eax),%eax
 3fe:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 402:	8b 5d 10             	mov    0x10(%ebp),%ebx
 405:	8b 45 ec             	mov    -0x14(%ebp),%eax
 408:	ba 00 00 00 00       	mov    $0x0,%edx
 40d:	f7 f3                	div    %ebx
 40f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 412:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 416:	75 c7                	jne    3df <printint+0x38>
  if(neg)
 418:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 41c:	74 0e                	je     42c <printint+0x85>
    buf[i++] = '-';
 41e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 421:	8d 50 01             	lea    0x1(%eax),%edx
 424:	89 55 f4             	mov    %edx,-0xc(%ebp)
 427:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 42c:	eb 1d                	jmp    44b <printint+0xa4>
    putc(fd, buf[i]);
 42e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 431:	8b 45 f4             	mov    -0xc(%ebp),%eax
 434:	01 d0                	add    %edx,%eax
 436:	0f b6 00             	movzbl (%eax),%eax
 439:	0f be c0             	movsbl %al,%eax
 43c:	83 ec 08             	sub    $0x8,%esp
 43f:	50                   	push   %eax
 440:	ff 75 08             	pushl  0x8(%ebp)
 443:	e8 3d ff ff ff       	call   385 <putc>
 448:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 44b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 44f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 453:	79 d9                	jns    42e <printint+0x87>
    putc(fd, buf[i]);
}
 455:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 458:	c9                   	leave  
 459:	c3                   	ret    

0000045a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 460:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 467:	8d 45 0c             	lea    0xc(%ebp),%eax
 46a:	83 c0 04             	add    $0x4,%eax
 46d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 470:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 477:	e9 59 01 00 00       	jmp    5d5 <printf+0x17b>
    c = fmt[i] & 0xff;
 47c:	8b 55 0c             	mov    0xc(%ebp),%edx
 47f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 482:	01 d0                	add    %edx,%eax
 484:	0f b6 00             	movzbl (%eax),%eax
 487:	0f be c0             	movsbl %al,%eax
 48a:	25 ff 00 00 00       	and    $0xff,%eax
 48f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 492:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 496:	75 2c                	jne    4c4 <printf+0x6a>
      if(c == '%'){
 498:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 49c:	75 0c                	jne    4aa <printf+0x50>
        state = '%';
 49e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4a5:	e9 27 01 00 00       	jmp    5d1 <printf+0x177>
      } else {
        putc(fd, c);
 4aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ad:	0f be c0             	movsbl %al,%eax
 4b0:	83 ec 08             	sub    $0x8,%esp
 4b3:	50                   	push   %eax
 4b4:	ff 75 08             	pushl  0x8(%ebp)
 4b7:	e8 c9 fe ff ff       	call   385 <putc>
 4bc:	83 c4 10             	add    $0x10,%esp
 4bf:	e9 0d 01 00 00       	jmp    5d1 <printf+0x177>
      }
    } else if(state == '%'){
 4c4:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4c8:	0f 85 03 01 00 00    	jne    5d1 <printf+0x177>
      if(c == 'd'){
 4ce:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d2:	75 1e                	jne    4f2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4d7:	8b 00                	mov    (%eax),%eax
 4d9:	6a 01                	push   $0x1
 4db:	6a 0a                	push   $0xa
 4dd:	50                   	push   %eax
 4de:	ff 75 08             	pushl  0x8(%ebp)
 4e1:	e8 c1 fe ff ff       	call   3a7 <printint>
 4e6:	83 c4 10             	add    $0x10,%esp
        ap++;
 4e9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4ed:	e9 d8 00 00 00       	jmp    5ca <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4f6:	74 06                	je     4fe <printf+0xa4>
 4f8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4fc:	75 1e                	jne    51c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 4fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 501:	8b 00                	mov    (%eax),%eax
 503:	6a 00                	push   $0x0
 505:	6a 10                	push   $0x10
 507:	50                   	push   %eax
 508:	ff 75 08             	pushl  0x8(%ebp)
 50b:	e8 97 fe ff ff       	call   3a7 <printint>
 510:	83 c4 10             	add    $0x10,%esp
        ap++;
 513:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 517:	e9 ae 00 00 00       	jmp    5ca <printf+0x170>
      } else if(c == 's'){
 51c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 520:	75 43                	jne    565 <printf+0x10b>
        s = (char*)*ap;
 522:	8b 45 e8             	mov    -0x18(%ebp),%eax
 525:	8b 00                	mov    (%eax),%eax
 527:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 532:	75 07                	jne    53b <printf+0xe1>
          s = "(null)";
 534:	c7 45 f4 41 08 00 00 	movl   $0x841,-0xc(%ebp)
        while(*s != 0){
 53b:	eb 1c                	jmp    559 <printf+0xff>
          putc(fd, *s);
 53d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 540:	0f b6 00             	movzbl (%eax),%eax
 543:	0f be c0             	movsbl %al,%eax
 546:	83 ec 08             	sub    $0x8,%esp
 549:	50                   	push   %eax
 54a:	ff 75 08             	pushl  0x8(%ebp)
 54d:	e8 33 fe ff ff       	call   385 <putc>
 552:	83 c4 10             	add    $0x10,%esp
          s++;
 555:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 559:	8b 45 f4             	mov    -0xc(%ebp),%eax
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	84 c0                	test   %al,%al
 561:	75 da                	jne    53d <printf+0xe3>
 563:	eb 65                	jmp    5ca <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 565:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 569:	75 1d                	jne    588 <printf+0x12e>
        putc(fd, *ap);
 56b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 56e:	8b 00                	mov    (%eax),%eax
 570:	0f be c0             	movsbl %al,%eax
 573:	83 ec 08             	sub    $0x8,%esp
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 06 fe ff ff       	call   385 <putc>
 57f:	83 c4 10             	add    $0x10,%esp
        ap++;
 582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 586:	eb 42                	jmp    5ca <printf+0x170>
      } else if(c == '%'){
 588:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 58c:	75 17                	jne    5a5 <printf+0x14b>
        putc(fd, c);
 58e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	83 ec 08             	sub    $0x8,%esp
 597:	50                   	push   %eax
 598:	ff 75 08             	pushl  0x8(%ebp)
 59b:	e8 e5 fd ff ff       	call   385 <putc>
 5a0:	83 c4 10             	add    $0x10,%esp
 5a3:	eb 25                	jmp    5ca <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a5:	83 ec 08             	sub    $0x8,%esp
 5a8:	6a 25                	push   $0x25
 5aa:	ff 75 08             	pushl  0x8(%ebp)
 5ad:	e8 d3 fd ff ff       	call   385 <putc>
 5b2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b8:	0f be c0             	movsbl %al,%eax
 5bb:	83 ec 08             	sub    $0x8,%esp
 5be:	50                   	push   %eax
 5bf:	ff 75 08             	pushl  0x8(%ebp)
 5c2:	e8 be fd ff ff       	call   385 <putc>
 5c7:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5ca:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d5:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5db:	01 d0                	add    %edx,%eax
 5dd:	0f b6 00             	movzbl (%eax),%eax
 5e0:	84 c0                	test   %al,%al
 5e2:	0f 85 94 fe ff ff    	jne    47c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e8:	c9                   	leave  
 5e9:	c3                   	ret    

000005ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ea:	55                   	push   %ebp
 5eb:	89 e5                	mov    %esp,%ebp
 5ed:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
 5f3:	83 e8 08             	sub    $0x8,%eax
 5f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f9:	a1 b0 0a 00 00       	mov    0xab0,%eax
 5fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 601:	eb 24                	jmp    627 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 603:	8b 45 fc             	mov    -0x4(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 60b:	77 12                	ja     61f <free+0x35>
 60d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 610:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 613:	77 24                	ja     639 <free+0x4f>
 615:	8b 45 fc             	mov    -0x4(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61d:	77 1a                	ja     639 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 622:	8b 00                	mov    (%eax),%eax
 624:	89 45 fc             	mov    %eax,-0x4(%ebp)
 627:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62d:	76 d4                	jbe    603 <free+0x19>
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8b 00                	mov    (%eax),%eax
 634:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 637:	76 ca                	jbe    603 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 639:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63c:	8b 40 04             	mov    0x4(%eax),%eax
 63f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 646:	8b 45 f8             	mov    -0x8(%ebp),%eax
 649:	01 c2                	add    %eax,%edx
 64b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	39 c2                	cmp    %eax,%edx
 652:	75 24                	jne    678 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 654:	8b 45 f8             	mov    -0x8(%ebp),%eax
 657:	8b 50 04             	mov    0x4(%eax),%edx
 65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	8b 40 04             	mov    0x4(%eax),%eax
 662:	01 c2                	add    %eax,%edx
 664:	8b 45 f8             	mov    -0x8(%ebp),%eax
 667:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 66a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	8b 10                	mov    (%eax),%edx
 671:	8b 45 f8             	mov    -0x8(%ebp),%eax
 674:	89 10                	mov    %edx,(%eax)
 676:	eb 0a                	jmp    682 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 678:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67b:	8b 10                	mov    (%eax),%edx
 67d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 680:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 682:	8b 45 fc             	mov    -0x4(%ebp),%eax
 685:	8b 40 04             	mov    0x4(%eax),%eax
 688:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 692:	01 d0                	add    %edx,%eax
 694:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 697:	75 20                	jne    6b9 <free+0xcf>
    p->s.size += bp->s.size;
 699:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69c:	8b 50 04             	mov    0x4(%eax),%edx
 69f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a2:	8b 40 04             	mov    0x4(%eax),%eax
 6a5:	01 c2                	add    %eax,%edx
 6a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6aa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b0:	8b 10                	mov    (%eax),%edx
 6b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b5:	89 10                	mov    %edx,(%eax)
 6b7:	eb 08                	jmp    6c1 <free+0xd7>
  } else
    p->s.ptr = bp;
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6bf:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	a3 b0 0a 00 00       	mov    %eax,0xab0
}
 6c9:	c9                   	leave  
 6ca:	c3                   	ret    

000006cb <morecore>:

static Header*
morecore(uint nu)
{
 6cb:	55                   	push   %ebp
 6cc:	89 e5                	mov    %esp,%ebp
 6ce:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d8:	77 07                	ja     6e1 <morecore+0x16>
    nu = 4096;
 6da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	c1 e0 03             	shl    $0x3,%eax
 6e7:	83 ec 0c             	sub    $0xc,%esp
 6ea:	50                   	push   %eax
 6eb:	e8 7d fc ff ff       	call   36d <sbrk>
 6f0:	83 c4 10             	add    $0x10,%esp
 6f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6fa:	75 07                	jne    703 <morecore+0x38>
    return 0;
 6fc:	b8 00 00 00 00       	mov    $0x0,%eax
 701:	eb 26                	jmp    729 <morecore+0x5e>
  hp = (Header*)p;
 703:	8b 45 f4             	mov    -0xc(%ebp),%eax
 706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 709:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70c:	8b 55 08             	mov    0x8(%ebp),%edx
 70f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 712:	8b 45 f0             	mov    -0x10(%ebp),%eax
 715:	83 c0 08             	add    $0x8,%eax
 718:	83 ec 0c             	sub    $0xc,%esp
 71b:	50                   	push   %eax
 71c:	e8 c9 fe ff ff       	call   5ea <free>
 721:	83 c4 10             	add    $0x10,%esp
  return freep;
 724:	a1 b0 0a 00 00       	mov    0xab0,%eax
}
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <malloc>:

void*
malloc(uint nbytes)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	83 c0 07             	add    $0x7,%eax
 737:	c1 e8 03             	shr    $0x3,%eax
 73a:	83 c0 01             	add    $0x1,%eax
 73d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 740:	a1 b0 0a 00 00       	mov    0xab0,%eax
 745:	89 45 f0             	mov    %eax,-0x10(%ebp)
 748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74c:	75 23                	jne    771 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 74e:	c7 45 f0 a8 0a 00 00 	movl   $0xaa8,-0x10(%ebp)
 755:	8b 45 f0             	mov    -0x10(%ebp),%eax
 758:	a3 b0 0a 00 00       	mov    %eax,0xab0
 75d:	a1 b0 0a 00 00       	mov    0xab0,%eax
 762:	a3 a8 0a 00 00       	mov    %eax,0xaa8
    base.s.size = 0;
 767:	c7 05 ac 0a 00 00 00 	movl   $0x0,0xaac
 76e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	8b 40 04             	mov    0x4(%eax),%eax
 77f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 782:	72 4d                	jb     7d1 <malloc+0xa6>
      if(p->s.size == nunits)
 784:	8b 45 f4             	mov    -0xc(%ebp),%eax
 787:	8b 40 04             	mov    0x4(%eax),%eax
 78a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 78d:	75 0c                	jne    79b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 10                	mov    (%eax),%edx
 794:	8b 45 f0             	mov    -0x10(%ebp),%eax
 797:	89 10                	mov    %edx,(%eax)
 799:	eb 26                	jmp    7c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7a4:	89 c2                	mov    %eax,%edx
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 40 04             	mov    0x4(%eax),%eax
 7b2:	c1 e0 03             	shl    $0x3,%eax
 7b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	a3 b0 0a 00 00       	mov    %eax,0xab0
      return (void*)(p + 1);
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	eb 3b                	jmp    80c <malloc+0xe1>
    }
    if(p == freep)
 7d1:	a1 b0 0a 00 00       	mov    0xab0,%eax
 7d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7d9:	75 1e                	jne    7f9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7db:	83 ec 0c             	sub    $0xc,%esp
 7de:	ff 75 ec             	pushl  -0x14(%ebp)
 7e1:	e8 e5 fe ff ff       	call   6cb <morecore>
 7e6:	83 c4 10             	add    $0x10,%esp
 7e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f0:	75 07                	jne    7f9 <malloc+0xce>
        return 0;
 7f2:	b8 00 00 00 00       	mov    $0x0,%eax
 7f7:	eb 13                	jmp    80c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 807:	e9 6d ff ff ff       	jmp    779 <malloc+0x4e>
}
 80c:	c9                   	leave  
 80d:	c3                   	ret    
