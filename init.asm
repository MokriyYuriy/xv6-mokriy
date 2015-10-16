
_init:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 80 08 00 00       	push   $0x880
  1b:	e8 74 03 00 00       	call   394 <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 80 08 00 00       	push   $0x880
  33:	e8 64 03 00 00       	call   39c <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 80 08 00 00       	push   $0x880
  45:	e8 4a 03 00 00       	call   394 <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 75 03 00 00       	call   3cc <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 68 03 00 00       	call   3cc <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 88 08 00 00       	push   $0x888
  6f:	6a 01                	push   $0x1
  71:	e8 53 04 00 00       	call   4c9 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 ce 02 00 00       	call   34c <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 9b 08 00 00       	push   $0x89b
  8f:	6a 01                	push   $0x1
  91:	e8 33 04 00 00       	call   4c9 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 b6 02 00 00       	call   354 <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 2c                	jne    d0 <main+0xd0>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 1c 0b 00 00       	push   $0xb1c
  ac:	68 7d 08 00 00       	push   $0x87d
  b1:	e8 d6 02 00 00       	call   38c <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 ae 08 00 00       	push   $0x8ae
  c1:	6a 01                	push   $0x1
  c3:	e8 01 04 00 00       	call   4c9 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 84 02 00 00       	call   354 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  d0:	eb 12                	jmp    e4 <main+0xe4>
      printf(1, "zombie!\n");
  d2:	83 ec 08             	sub    $0x8,%esp
  d5:	68 c4 08 00 00       	push   $0x8c4
  da:	6a 01                	push   $0x1
  dc:	e8 e8 03 00 00       	call   4c9 <printf>
  e1:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e4:	e8 73 02 00 00       	call   35c <wait>
  e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  f0:	78 08                	js     fa <main+0xfa>
  f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  f8:	75 d8                	jne    d2 <main+0xd2>
      printf(1, "zombie!\n");
  }
  fa:	e9 68 ff ff ff       	jmp    67 <main+0x67>

000000ff <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	57                   	push   %edi
 103:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 55 10             	mov    0x10(%ebp),%edx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 cb                	mov    %ecx,%ebx
 10f:	89 df                	mov    %ebx,%edi
 111:	89 d1                	mov    %edx,%ecx
 113:	fc                   	cld    
 114:	f3 aa                	rep stos %al,%es:(%edi)
 116:	89 ca                	mov    %ecx,%edx
 118:	89 fb                	mov    %edi,%ebx
 11a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 120:	5b                   	pop    %ebx
 121:	5f                   	pop    %edi
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12a:	8b 45 08             	mov    0x8(%ebp),%eax
 12d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 130:	90                   	nop
 131:	8b 45 08             	mov    0x8(%ebp),%eax
 134:	8d 50 01             	lea    0x1(%eax),%edx
 137:	89 55 08             	mov    %edx,0x8(%ebp)
 13a:	8b 55 0c             	mov    0xc(%ebp),%edx
 13d:	8d 4a 01             	lea    0x1(%edx),%ecx
 140:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 143:	0f b6 12             	movzbl (%edx),%edx
 146:	88 10                	mov    %dl,(%eax)
 148:	0f b6 00             	movzbl (%eax),%eax
 14b:	84 c0                	test   %al,%al
 14d:	75 e2                	jne    131 <strcpy+0xd>
    ;
  return os;
 14f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 152:	c9                   	leave  
 153:	c3                   	ret    

00000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 157:	eb 08                	jmp    161 <strcmp+0xd>
    p++, q++;
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	84 c0                	test   %al,%al
 169:	74 10                	je     17b <strcmp+0x27>
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 10             	movzbl (%eax),%edx
 171:	8b 45 0c             	mov    0xc(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	38 c2                	cmp    %al,%dl
 179:	74 de                	je     159 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 00             	movzbl (%eax),%eax
 181:	0f b6 d0             	movzbl %al,%edx
 184:	8b 45 0c             	mov    0xc(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	0f b6 c0             	movzbl %al,%eax
 18d:	29 c2                	sub    %eax,%edx
 18f:	89 d0                	mov    %edx,%eax
}
 191:	5d                   	pop    %ebp
 192:	c3                   	ret    

00000193 <strlen>:

uint
strlen(char *s)
{
 193:	55                   	push   %ebp
 194:	89 e5                	mov    %esp,%ebp
 196:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 199:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a0:	eb 04                	jmp    1a6 <strlen+0x13>
 1a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	01 d0                	add    %edx,%eax
 1ae:	0f b6 00             	movzbl (%eax),%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	75 ed                	jne    1a2 <strlen+0xf>
    ;
  return n;
 1b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1bd:	8b 45 10             	mov    0x10(%ebp),%eax
 1c0:	50                   	push   %eax
 1c1:	ff 75 0c             	pushl  0xc(%ebp)
 1c4:	ff 75 08             	pushl  0x8(%ebp)
 1c7:	e8 33 ff ff ff       	call   ff <stosb>
 1cc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d2:	c9                   	leave  
 1d3:	c3                   	ret    

000001d4 <strchr>:

char*
strchr(const char *s, char c)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 04             	sub    $0x4,%esp
 1da:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e0:	eb 14                	jmp    1f6 <strchr+0x22>
    if(*s == c)
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	0f b6 00             	movzbl (%eax),%eax
 1e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1eb:	75 05                	jne    1f2 <strchr+0x1e>
      return (char*)s;
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	eb 13                	jmp    205 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	0f b6 00             	movzbl (%eax),%eax
 1fc:	84 c0                	test   %al,%al
 1fe:	75 e2                	jne    1e2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 200:	b8 00 00 00 00       	mov    $0x0,%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <gets>:

char*
gets(char *buf, int max)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 214:	eb 44                	jmp    25a <gets+0x53>
    cc = read(0, &c, 1);
 216:	83 ec 04             	sub    $0x4,%esp
 219:	6a 01                	push   $0x1
 21b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 21e:	50                   	push   %eax
 21f:	6a 00                	push   $0x0
 221:	e8 46 01 00 00       	call   36c <read>
 226:	83 c4 10             	add    $0x10,%esp
 229:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 230:	7f 02                	jg     234 <gets+0x2d>
      break;
 232:	eb 31                	jmp    265 <gets+0x5e>
    buf[i++] = c;
 234:	8b 45 f4             	mov    -0xc(%ebp),%eax
 237:	8d 50 01             	lea    0x1(%eax),%edx
 23a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23d:	89 c2                	mov    %eax,%edx
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	01 c2                	add    %eax,%edx
 244:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 248:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24e:	3c 0a                	cmp    $0xa,%al
 250:	74 13                	je     265 <gets+0x5e>
 252:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 256:	3c 0d                	cmp    $0xd,%al
 258:	74 0b                	je     265 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25d:	83 c0 01             	add    $0x1,%eax
 260:	3b 45 0c             	cmp    0xc(%ebp),%eax
 263:	7c b1                	jl     216 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 265:	8b 55 f4             	mov    -0xc(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <stat>:

int
stat(char *n, struct stat *st)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27b:	83 ec 08             	sub    $0x8,%esp
 27e:	6a 00                	push   $0x0
 280:	ff 75 08             	pushl  0x8(%ebp)
 283:	e8 0c 01 00 00       	call   394 <open>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 28e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 292:	79 07                	jns    29b <stat+0x26>
    return -1;
 294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 299:	eb 25                	jmp    2c0 <stat+0x4b>
  r = fstat(fd, st);
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	ff 75 0c             	pushl  0xc(%ebp)
 2a1:	ff 75 f4             	pushl  -0xc(%ebp)
 2a4:	e8 03 01 00 00       	call   3ac <fstat>
 2a9:	83 c4 10             	add    $0x10,%esp
 2ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2af:	83 ec 0c             	sub    $0xc,%esp
 2b2:	ff 75 f4             	pushl  -0xc(%ebp)
 2b5:	e8 c2 00 00 00       	call   37c <close>
 2ba:	83 c4 10             	add    $0x10,%esp
  return r;
 2bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c0:	c9                   	leave  
 2c1:	c3                   	ret    

000002c2 <atoi>:

int
atoi(const char *s)
{
 2c2:	55                   	push   %ebp
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2cf:	eb 25                	jmp    2f6 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d4:	89 d0                	mov    %edx,%eax
 2d6:	c1 e0 02             	shl    $0x2,%eax
 2d9:	01 d0                	add    %edx,%eax
 2db:	01 c0                	add    %eax,%eax
 2dd:	89 c1                	mov    %eax,%ecx
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	8d 50 01             	lea    0x1(%eax),%edx
 2e5:	89 55 08             	mov    %edx,0x8(%ebp)
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	0f be c0             	movsbl %al,%eax
 2ee:	01 c8                	add    %ecx,%eax
 2f0:	83 e8 30             	sub    $0x30,%eax
 2f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 2f                	cmp    $0x2f,%al
 2fe:	7e 0a                	jle    30a <atoi+0x48>
 300:	8b 45 08             	mov    0x8(%ebp),%eax
 303:	0f b6 00             	movzbl (%eax),%eax
 306:	3c 39                	cmp    $0x39,%al
 308:	7e c7                	jle    2d1 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 30a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30d:	c9                   	leave  
 30e:	c3                   	ret    

0000030f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 30f:	55                   	push   %ebp
 310:	89 e5                	mov    %esp,%ebp
 312:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 321:	eb 17                	jmp    33a <memmove+0x2b>
    *dst++ = *src++;
 323:	8b 45 fc             	mov    -0x4(%ebp),%eax
 326:	8d 50 01             	lea    0x1(%eax),%edx
 329:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32f:	8d 4a 01             	lea    0x1(%edx),%ecx
 332:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 335:	0f b6 12             	movzbl (%edx),%edx
 338:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33a:	8b 45 10             	mov    0x10(%ebp),%eax
 33d:	8d 50 ff             	lea    -0x1(%eax),%edx
 340:	89 55 10             	mov    %edx,0x10(%ebp)
 343:	85 c0                	test   %eax,%eax
 345:	7f dc                	jg     323 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 347:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34a:	c9                   	leave  
 34b:	c3                   	ret    

0000034c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34c:	b8 01 00 00 00       	mov    $0x1,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <exit>:
SYSCALL(exit)
 354:	b8 02 00 00 00       	mov    $0x2,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <wait>:
SYSCALL(wait)
 35c:	b8 03 00 00 00       	mov    $0x3,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <pipe>:
SYSCALL(pipe)
 364:	b8 04 00 00 00       	mov    $0x4,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <read>:
SYSCALL(read)
 36c:	b8 05 00 00 00       	mov    $0x5,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <write>:
SYSCALL(write)
 374:	b8 10 00 00 00       	mov    $0x10,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <close>:
SYSCALL(close)
 37c:	b8 15 00 00 00       	mov    $0x15,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <kill>:
SYSCALL(kill)
 384:	b8 06 00 00 00       	mov    $0x6,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <exec>:
SYSCALL(exec)
 38c:	b8 07 00 00 00       	mov    $0x7,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <open>:
SYSCALL(open)
 394:	b8 0f 00 00 00       	mov    $0xf,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <mknod>:
SYSCALL(mknod)
 39c:	b8 11 00 00 00       	mov    $0x11,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <unlink>:
SYSCALL(unlink)
 3a4:	b8 12 00 00 00       	mov    $0x12,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <fstat>:
SYSCALL(fstat)
 3ac:	b8 08 00 00 00       	mov    $0x8,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <link>:
SYSCALL(link)
 3b4:	b8 13 00 00 00       	mov    $0x13,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <mkdir>:
SYSCALL(mkdir)
 3bc:	b8 14 00 00 00       	mov    $0x14,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <chdir>:
SYSCALL(chdir)
 3c4:	b8 09 00 00 00       	mov    $0x9,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <dup>:
SYSCALL(dup)
 3cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <getpid>:
SYSCALL(getpid)
 3d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <sbrk>:
SYSCALL(sbrk)
 3dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <sleep>:
SYSCALL(sleep)
 3e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <uptime>:
SYSCALL(uptime)
 3ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	83 ec 18             	sub    $0x18,%esp
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 400:	83 ec 04             	sub    $0x4,%esp
 403:	6a 01                	push   $0x1
 405:	8d 45 f4             	lea    -0xc(%ebp),%eax
 408:	50                   	push   %eax
 409:	ff 75 08             	pushl  0x8(%ebp)
 40c:	e8 63 ff ff ff       	call   374 <write>
 411:	83 c4 10             	add    $0x10,%esp
}
 414:	c9                   	leave  
 415:	c3                   	ret    

00000416 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 416:	55                   	push   %ebp
 417:	89 e5                	mov    %esp,%ebp
 419:	53                   	push   %ebx
 41a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 41d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 424:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 428:	74 17                	je     441 <printint+0x2b>
 42a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 42e:	79 11                	jns    441 <printint+0x2b>
    neg = 1;
 430:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 437:	8b 45 0c             	mov    0xc(%ebp),%eax
 43a:	f7 d8                	neg    %eax
 43c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 43f:	eb 06                	jmp    447 <printint+0x31>
  } else {
    x = xx;
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 447:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 44e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 451:	8d 41 01             	lea    0x1(%ecx),%eax
 454:	89 45 f4             	mov    %eax,-0xc(%ebp)
 457:	8b 5d 10             	mov    0x10(%ebp),%ebx
 45a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 45d:	ba 00 00 00 00       	mov    $0x0,%edx
 462:	f7 f3                	div    %ebx
 464:	89 d0                	mov    %edx,%eax
 466:	0f b6 80 24 0b 00 00 	movzbl 0xb24(%eax),%eax
 46d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 471:	8b 5d 10             	mov    0x10(%ebp),%ebx
 474:	8b 45 ec             	mov    -0x14(%ebp),%eax
 477:	ba 00 00 00 00       	mov    $0x0,%edx
 47c:	f7 f3                	div    %ebx
 47e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 481:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 485:	75 c7                	jne    44e <printint+0x38>
  if(neg)
 487:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 48b:	74 0e                	je     49b <printint+0x85>
    buf[i++] = '-';
 48d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 490:	8d 50 01             	lea    0x1(%eax),%edx
 493:	89 55 f4             	mov    %edx,-0xc(%ebp)
 496:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 49b:	eb 1d                	jmp    4ba <printint+0xa4>
    putc(fd, buf[i]);
 49d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a3:	01 d0                	add    %edx,%eax
 4a5:	0f b6 00             	movzbl (%eax),%eax
 4a8:	0f be c0             	movsbl %al,%eax
 4ab:	83 ec 08             	sub    $0x8,%esp
 4ae:	50                   	push   %eax
 4af:	ff 75 08             	pushl  0x8(%ebp)
 4b2:	e8 3d ff ff ff       	call   3f4 <putc>
 4b7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4ba:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4c2:	79 d9                	jns    49d <printint+0x87>
    putc(fd, buf[i]);
}
 4c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4c7:	c9                   	leave  
 4c8:	c3                   	ret    

000004c9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4d6:	8d 45 0c             	lea    0xc(%ebp),%eax
 4d9:	83 c0 04             	add    $0x4,%eax
 4dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4e6:	e9 59 01 00 00       	jmp    644 <printf+0x17b>
    c = fmt[i] & 0xff;
 4eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 4ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4f1:	01 d0                	add    %edx,%eax
 4f3:	0f b6 00             	movzbl (%eax),%eax
 4f6:	0f be c0             	movsbl %al,%eax
 4f9:	25 ff 00 00 00       	and    $0xff,%eax
 4fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 501:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 505:	75 2c                	jne    533 <printf+0x6a>
      if(c == '%'){
 507:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 50b:	75 0c                	jne    519 <printf+0x50>
        state = '%';
 50d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 514:	e9 27 01 00 00       	jmp    640 <printf+0x177>
      } else {
        putc(fd, c);
 519:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 51c:	0f be c0             	movsbl %al,%eax
 51f:	83 ec 08             	sub    $0x8,%esp
 522:	50                   	push   %eax
 523:	ff 75 08             	pushl  0x8(%ebp)
 526:	e8 c9 fe ff ff       	call   3f4 <putc>
 52b:	83 c4 10             	add    $0x10,%esp
 52e:	e9 0d 01 00 00       	jmp    640 <printf+0x177>
      }
    } else if(state == '%'){
 533:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 537:	0f 85 03 01 00 00    	jne    640 <printf+0x177>
      if(c == 'd'){
 53d:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 541:	75 1e                	jne    561 <printf+0x98>
        printint(fd, *ap, 10, 1);
 543:	8b 45 e8             	mov    -0x18(%ebp),%eax
 546:	8b 00                	mov    (%eax),%eax
 548:	6a 01                	push   $0x1
 54a:	6a 0a                	push   $0xa
 54c:	50                   	push   %eax
 54d:	ff 75 08             	pushl  0x8(%ebp)
 550:	e8 c1 fe ff ff       	call   416 <printint>
 555:	83 c4 10             	add    $0x10,%esp
        ap++;
 558:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 55c:	e9 d8 00 00 00       	jmp    639 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 561:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 565:	74 06                	je     56d <printf+0xa4>
 567:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 56b:	75 1e                	jne    58b <printf+0xc2>
        printint(fd, *ap, 16, 0);
 56d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 570:	8b 00                	mov    (%eax),%eax
 572:	6a 00                	push   $0x0
 574:	6a 10                	push   $0x10
 576:	50                   	push   %eax
 577:	ff 75 08             	pushl  0x8(%ebp)
 57a:	e8 97 fe ff ff       	call   416 <printint>
 57f:	83 c4 10             	add    $0x10,%esp
        ap++;
 582:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 586:	e9 ae 00 00 00       	jmp    639 <printf+0x170>
      } else if(c == 's'){
 58b:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 58f:	75 43                	jne    5d4 <printf+0x10b>
        s = (char*)*ap;
 591:	8b 45 e8             	mov    -0x18(%ebp),%eax
 594:	8b 00                	mov    (%eax),%eax
 596:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 599:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 59d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5a1:	75 07                	jne    5aa <printf+0xe1>
          s = "(null)";
 5a3:	c7 45 f4 cd 08 00 00 	movl   $0x8cd,-0xc(%ebp)
        while(*s != 0){
 5aa:	eb 1c                	jmp    5c8 <printf+0xff>
          putc(fd, *s);
 5ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5af:	0f b6 00             	movzbl (%eax),%eax
 5b2:	0f be c0             	movsbl %al,%eax
 5b5:	83 ec 08             	sub    $0x8,%esp
 5b8:	50                   	push   %eax
 5b9:	ff 75 08             	pushl  0x8(%ebp)
 5bc:	e8 33 fe ff ff       	call   3f4 <putc>
 5c1:	83 c4 10             	add    $0x10,%esp
          s++;
 5c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	0f b6 00             	movzbl (%eax),%eax
 5ce:	84 c0                	test   %al,%al
 5d0:	75 da                	jne    5ac <printf+0xe3>
 5d2:	eb 65                	jmp    639 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5d4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5d8:	75 1d                	jne    5f7 <printf+0x12e>
        putc(fd, *ap);
 5da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5dd:	8b 00                	mov    (%eax),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	83 ec 08             	sub    $0x8,%esp
 5e5:	50                   	push   %eax
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 06 fe ff ff       	call   3f4 <putc>
 5ee:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f5:	eb 42                	jmp    639 <printf+0x170>
      } else if(c == '%'){
 5f7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5fb:	75 17                	jne    614 <printf+0x14b>
        putc(fd, c);
 5fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 600:	0f be c0             	movsbl %al,%eax
 603:	83 ec 08             	sub    $0x8,%esp
 606:	50                   	push   %eax
 607:	ff 75 08             	pushl  0x8(%ebp)
 60a:	e8 e5 fd ff ff       	call   3f4 <putc>
 60f:	83 c4 10             	add    $0x10,%esp
 612:	eb 25                	jmp    639 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 614:	83 ec 08             	sub    $0x8,%esp
 617:	6a 25                	push   $0x25
 619:	ff 75 08             	pushl  0x8(%ebp)
 61c:	e8 d3 fd ff ff       	call   3f4 <putc>
 621:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 624:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 627:	0f be c0             	movsbl %al,%eax
 62a:	83 ec 08             	sub    $0x8,%esp
 62d:	50                   	push   %eax
 62e:	ff 75 08             	pushl  0x8(%ebp)
 631:	e8 be fd ff ff       	call   3f4 <putc>
 636:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 639:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 640:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 644:	8b 55 0c             	mov    0xc(%ebp),%edx
 647:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64a:	01 d0                	add    %edx,%eax
 64c:	0f b6 00             	movzbl (%eax),%eax
 64f:	84 c0                	test   %al,%al
 651:	0f 85 94 fe ff ff    	jne    4eb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 657:	c9                   	leave  
 658:	c3                   	ret    

00000659 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 659:	55                   	push   %ebp
 65a:	89 e5                	mov    %esp,%ebp
 65c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 65f:	8b 45 08             	mov    0x8(%ebp),%eax
 662:	83 e8 08             	sub    $0x8,%eax
 665:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 668:	a1 40 0b 00 00       	mov    0xb40,%eax
 66d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 670:	eb 24                	jmp    696 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 00                	mov    (%eax),%eax
 677:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 67a:	77 12                	ja     68e <free+0x35>
 67c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 682:	77 24                	ja     6a8 <free+0x4f>
 684:	8b 45 fc             	mov    -0x4(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68c:	77 1a                	ja     6a8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 68e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 691:	8b 00                	mov    (%eax),%eax
 693:	89 45 fc             	mov    %eax,-0x4(%ebp)
 696:	8b 45 f8             	mov    -0x8(%ebp),%eax
 699:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 69c:	76 d4                	jbe    672 <free+0x19>
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6a6:	76 ca                	jbe    672 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ab:	8b 40 04             	mov    0x4(%eax),%eax
 6ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	01 c2                	add    %eax,%edx
 6ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	39 c2                	cmp    %eax,%edx
 6c1:	75 24                	jne    6e7 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c6:	8b 50 04             	mov    0x4(%eax),%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	8b 40 04             	mov    0x4(%eax),%eax
 6d1:	01 c2                	add    %eax,%edx
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6dc:	8b 00                	mov    (%eax),%eax
 6de:	8b 10                	mov    (%eax),%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 10                	mov    %edx,(%eax)
 6e5:	eb 0a                	jmp    6f1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ea:	8b 10                	mov    (%eax),%edx
 6ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ef:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 40 04             	mov    0x4(%eax),%eax
 6f7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	01 d0                	add    %edx,%eax
 703:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 706:	75 20                	jne    728 <free+0xcf>
    p->s.size += bp->s.size;
 708:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70b:	8b 50 04             	mov    0x4(%eax),%edx
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	8b 40 04             	mov    0x4(%eax),%eax
 714:	01 c2                	add    %eax,%edx
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 71c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71f:	8b 10                	mov    (%eax),%edx
 721:	8b 45 fc             	mov    -0x4(%ebp),%eax
 724:	89 10                	mov    %edx,(%eax)
 726:	eb 08                	jmp    730 <free+0xd7>
  } else
    p->s.ptr = bp;
 728:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 72e:	89 10                	mov    %edx,(%eax)
  freep = p;
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	a3 40 0b 00 00       	mov    %eax,0xb40
}
 738:	c9                   	leave  
 739:	c3                   	ret    

0000073a <morecore>:

static Header*
morecore(uint nu)
{
 73a:	55                   	push   %ebp
 73b:	89 e5                	mov    %esp,%ebp
 73d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 740:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 747:	77 07                	ja     750 <morecore+0x16>
    nu = 4096;
 749:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	c1 e0 03             	shl    $0x3,%eax
 756:	83 ec 0c             	sub    $0xc,%esp
 759:	50                   	push   %eax
 75a:	e8 7d fc ff ff       	call   3dc <sbrk>
 75f:	83 c4 10             	add    $0x10,%esp
 762:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 765:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 769:	75 07                	jne    772 <morecore+0x38>
    return 0;
 76b:	b8 00 00 00 00       	mov    $0x0,%eax
 770:	eb 26                	jmp    798 <morecore+0x5e>
  hp = (Header*)p;
 772:	8b 45 f4             	mov    -0xc(%ebp),%eax
 775:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 778:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77b:	8b 55 08             	mov    0x8(%ebp),%edx
 77e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 781:	8b 45 f0             	mov    -0x10(%ebp),%eax
 784:	83 c0 08             	add    $0x8,%eax
 787:	83 ec 0c             	sub    $0xc,%esp
 78a:	50                   	push   %eax
 78b:	e8 c9 fe ff ff       	call   659 <free>
 790:	83 c4 10             	add    $0x10,%esp
  return freep;
 793:	a1 40 0b 00 00       	mov    0xb40,%eax
}
 798:	c9                   	leave  
 799:	c3                   	ret    

0000079a <malloc>:

void*
malloc(uint nbytes)
{
 79a:	55                   	push   %ebp
 79b:	89 e5                	mov    %esp,%ebp
 79d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a0:	8b 45 08             	mov    0x8(%ebp),%eax
 7a3:	83 c0 07             	add    $0x7,%eax
 7a6:	c1 e8 03             	shr    $0x3,%eax
 7a9:	83 c0 01             	add    $0x1,%eax
 7ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7af:	a1 40 0b 00 00       	mov    0xb40,%eax
 7b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7bb:	75 23                	jne    7e0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7bd:	c7 45 f0 38 0b 00 00 	movl   $0xb38,-0x10(%ebp)
 7c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c7:	a3 40 0b 00 00       	mov    %eax,0xb40
 7cc:	a1 40 0b 00 00       	mov    0xb40,%eax
 7d1:	a3 38 0b 00 00       	mov    %eax,0xb38
    base.s.size = 0;
 7d6:	c7 05 3c 0b 00 00 00 	movl   $0x0,0xb3c
 7dd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7f1:	72 4d                	jb     840 <malloc+0xa6>
      if(p->s.size == nunits)
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	8b 40 04             	mov    0x4(%eax),%eax
 7f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7fc:	75 0c                	jne    80a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	8b 10                	mov    (%eax),%edx
 803:	8b 45 f0             	mov    -0x10(%ebp),%eax
 806:	89 10                	mov    %edx,(%eax)
 808:	eb 26                	jmp    830 <malloc+0x96>
      else {
        p->s.size -= nunits;
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	8b 40 04             	mov    0x4(%eax),%eax
 810:	2b 45 ec             	sub    -0x14(%ebp),%eax
 813:	89 c2                	mov    %eax,%edx
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81e:	8b 40 04             	mov    0x4(%eax),%eax
 821:	c1 e0 03             	shl    $0x3,%eax
 824:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 82d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 830:	8b 45 f0             	mov    -0x10(%ebp),%eax
 833:	a3 40 0b 00 00       	mov    %eax,0xb40
      return (void*)(p + 1);
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	83 c0 08             	add    $0x8,%eax
 83e:	eb 3b                	jmp    87b <malloc+0xe1>
    }
    if(p == freep)
 840:	a1 40 0b 00 00       	mov    0xb40,%eax
 845:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 848:	75 1e                	jne    868 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 84a:	83 ec 0c             	sub    $0xc,%esp
 84d:	ff 75 ec             	pushl  -0x14(%ebp)
 850:	e8 e5 fe ff ff       	call   73a <morecore>
 855:	83 c4 10             	add    $0x10,%esp
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
 85b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 85f:	75 07                	jne    868 <malloc+0xce>
        return 0;
 861:	b8 00 00 00 00       	mov    $0x0,%eax
 866:	eb 13                	jmp    87b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 876:	e9 6d ff ff ff       	jmp    7e8 <malloc+0x4e>
}
 87b:	c9                   	leave  
 87c:	c3                   	ret    
