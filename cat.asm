
_cat:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 80 0b 00 00       	push   $0xb80
  13:	6a 01                	push   $0x1
  15:	e8 69 03 00 00       	call   383 <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 80 0b 00 00       	push   $0xb80
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 49 03 00 00       	call   37b <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 8c 08 00 00       	push   $0x88c
  4c:	6a 01                	push   $0x1
  4e:	e8 85 04 00 00       	call   4d8 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 08 03 00 00       	call   363 <exit>
  }
}
  5b:	c9                   	leave  
  5c:	c3                   	ret    

0000005d <main>:

int
main(int argc, char *argv[])
{
  5d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  61:	83 e4 f0             	and    $0xfffffff0,%esp
  64:	ff 71 fc             	pushl  -0x4(%ecx)
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	53                   	push   %ebx
  6b:	51                   	push   %ecx
  6c:	83 ec 10             	sub    $0x10,%esp
  6f:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  71:	83 3b 01             	cmpl   $0x1,(%ebx)
  74:	7f 12                	jg     88 <main+0x2b>
    cat(0);
  76:	83 ec 0c             	sub    $0xc,%esp
  79:	6a 00                	push   $0x0
  7b:	e8 80 ff ff ff       	call   0 <cat>
  80:	83 c4 10             	add    $0x10,%esp
    exit();
  83:	e8 db 02 00 00       	call   363 <exit>
  }

  for(i = 1; i < argc; i++){
  88:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  8f:	eb 71                	jmp    102 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9b:	8b 43 04             	mov    0x4(%ebx),%eax
  9e:	01 d0                	add    %edx,%eax
  a0:	8b 00                	mov    (%eax),%eax
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	6a 00                	push   $0x0
  a7:	50                   	push   %eax
  a8:	e8 f6 02 00 00       	call   3a3 <open>
  ad:	83 c4 10             	add    $0x10,%esp
  b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b7:	79 29                	jns    e2 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c3:	8b 43 04             	mov    0x4(%ebx),%eax
  c6:	01 d0                	add    %edx,%eax
  c8:	8b 00                	mov    (%eax),%eax
  ca:	83 ec 04             	sub    $0x4,%esp
  cd:	50                   	push   %eax
  ce:	68 9d 08 00 00       	push   $0x89d
  d3:	6a 01                	push   $0x1
  d5:	e8 fe 03 00 00       	call   4d8 <printf>
  da:	83 c4 10             	add    $0x10,%esp
      exit();
  dd:	e8 81 02 00 00       	call   363 <exit>
    }
    cat(fd);
  e2:	83 ec 0c             	sub    $0xc,%esp
  e5:	ff 75 f0             	pushl  -0x10(%ebp)
  e8:	e8 13 ff ff ff       	call   0 <cat>
  ed:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f0:	83 ec 0c             	sub    $0xc,%esp
  f3:	ff 75 f0             	pushl  -0x10(%ebp)
  f6:	e8 90 02 00 00       	call   38b <close>
  fb:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 102:	8b 45 f4             	mov    -0xc(%ebp),%eax
 105:	3b 03                	cmp    (%ebx),%eax
 107:	7c 88                	jl     91 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 109:	e8 55 02 00 00       	call   363 <exit>

0000010e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10e:	55                   	push   %ebp
 10f:	89 e5                	mov    %esp,%ebp
 111:	57                   	push   %edi
 112:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 113:	8b 4d 08             	mov    0x8(%ebp),%ecx
 116:	8b 55 10             	mov    0x10(%ebp),%edx
 119:	8b 45 0c             	mov    0xc(%ebp),%eax
 11c:	89 cb                	mov    %ecx,%ebx
 11e:	89 df                	mov    %ebx,%edi
 120:	89 d1                	mov    %edx,%ecx
 122:	fc                   	cld    
 123:	f3 aa                	rep stos %al,%es:(%edi)
 125:	89 ca                	mov    %ecx,%edx
 127:	89 fb                	mov    %edi,%ebx
 129:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 12f:	5b                   	pop    %ebx
 130:	5f                   	pop    %edi
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    

00000133 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 133:	55                   	push   %ebp
 134:	89 e5                	mov    %esp,%ebp
 136:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13f:	90                   	nop
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	8d 50 01             	lea    0x1(%eax),%edx
 146:	89 55 08             	mov    %edx,0x8(%ebp)
 149:	8b 55 0c             	mov    0xc(%ebp),%edx
 14c:	8d 4a 01             	lea    0x1(%edx),%ecx
 14f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 152:	0f b6 12             	movzbl (%edx),%edx
 155:	88 10                	mov    %dl,(%eax)
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	75 e2                	jne    140 <strcpy+0xd>
    ;
  return os;
 15e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 161:	c9                   	leave  
 162:	c3                   	ret    

00000163 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 166:	eb 08                	jmp    170 <strcmp+0xd>
    p++, q++;
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	84 c0                	test   %al,%al
 178:	74 10                	je     18a <strcmp+0x27>
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 10             	movzbl (%eax),%edx
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	38 c2                	cmp    %al,%dl
 188:	74 de                	je     168 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	0f b6 d0             	movzbl %al,%edx
 193:	8b 45 0c             	mov    0xc(%ebp),%eax
 196:	0f b6 00             	movzbl (%eax),%eax
 199:	0f b6 c0             	movzbl %al,%eax
 19c:	29 c2                	sub    %eax,%edx
 19e:	89 d0                	mov    %edx,%eax
}
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret    

000001a2 <strlen>:

uint
strlen(char *s)
{
 1a2:	55                   	push   %ebp
 1a3:	89 e5                	mov    %esp,%ebp
 1a5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1af:	eb 04                	jmp    1b5 <strlen+0x13>
 1b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	01 d0                	add    %edx,%eax
 1bd:	0f b6 00             	movzbl (%eax),%eax
 1c0:	84 c0                	test   %al,%al
 1c2:	75 ed                	jne    1b1 <strlen+0xf>
    ;
  return n;
 1c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    

000001c9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1cc:	8b 45 10             	mov    0x10(%ebp),%eax
 1cf:	50                   	push   %eax
 1d0:	ff 75 0c             	pushl  0xc(%ebp)
 1d3:	ff 75 08             	pushl  0x8(%ebp)
 1d6:	e8 33 ff ff ff       	call   10e <stosb>
 1db:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e1:	c9                   	leave  
 1e2:	c3                   	ret    

000001e3 <strchr>:

char*
strchr(const char *s, char c)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 04             	sub    $0x4,%esp
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ef:	eb 14                	jmp    205 <strchr+0x22>
    if(*s == c)
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	0f b6 00             	movzbl (%eax),%eax
 1f7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fa:	75 05                	jne    201 <strchr+0x1e>
      return (char*)s;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	eb 13                	jmp    214 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 201:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	84 c0                	test   %al,%al
 20d:	75 e2                	jne    1f1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 20f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 214:	c9                   	leave  
 215:	c3                   	ret    

00000216 <gets>:

char*
gets(char *buf, int max)
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
 219:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 223:	eb 44                	jmp    269 <gets+0x53>
    cc = read(0, &c, 1);
 225:	83 ec 04             	sub    $0x4,%esp
 228:	6a 01                	push   $0x1
 22a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22d:	50                   	push   %eax
 22e:	6a 00                	push   $0x0
 230:	e8 46 01 00 00       	call   37b <read>
 235:	83 c4 10             	add    $0x10,%esp
 238:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 23f:	7f 02                	jg     243 <gets+0x2d>
      break;
 241:	eb 31                	jmp    274 <gets+0x5e>
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 13                	je     274 <gets+0x5e>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0b                	je     274 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 272:	7c b1                	jl     225 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 274:	8b 55 f4             	mov    -0xc(%ebp),%edx
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	01 d0                	add    %edx,%eax
 27c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 282:	c9                   	leave  
 283:	c3                   	ret    

00000284 <stat>:

int
stat(char *n, struct stat *st)
{
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28a:	83 ec 08             	sub    $0x8,%esp
 28d:	6a 00                	push   $0x0
 28f:	ff 75 08             	pushl  0x8(%ebp)
 292:	e8 0c 01 00 00       	call   3a3 <open>
 297:	83 c4 10             	add    $0x10,%esp
 29a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 29d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a1:	79 07                	jns    2aa <stat+0x26>
    return -1;
 2a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a8:	eb 25                	jmp    2cf <stat+0x4b>
  r = fstat(fd, st);
 2aa:	83 ec 08             	sub    $0x8,%esp
 2ad:	ff 75 0c             	pushl  0xc(%ebp)
 2b0:	ff 75 f4             	pushl  -0xc(%ebp)
 2b3:	e8 03 01 00 00       	call   3bb <fstat>
 2b8:	83 c4 10             	add    $0x10,%esp
 2bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2be:	83 ec 0c             	sub    $0xc,%esp
 2c1:	ff 75 f4             	pushl  -0xc(%ebp)
 2c4:	e8 c2 00 00 00       	call   38b <close>
 2c9:	83 c4 10             	add    $0x10,%esp
  return r;
 2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2cf:	c9                   	leave  
 2d0:	c3                   	ret    

000002d1 <atoi>:

int
atoi(const char *s)
{
 2d1:	55                   	push   %ebp
 2d2:	89 e5                	mov    %esp,%ebp
 2d4:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2de:	eb 25                	jmp    305 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e3:	89 d0                	mov    %edx,%eax
 2e5:	c1 e0 02             	shl    $0x2,%eax
 2e8:	01 d0                	add    %edx,%eax
 2ea:	01 c0                	add    %eax,%eax
 2ec:	89 c1                	mov    %eax,%ecx
 2ee:	8b 45 08             	mov    0x8(%ebp),%eax
 2f1:	8d 50 01             	lea    0x1(%eax),%edx
 2f4:	89 55 08             	mov    %edx,0x8(%ebp)
 2f7:	0f b6 00             	movzbl (%eax),%eax
 2fa:	0f be c0             	movsbl %al,%eax
 2fd:	01 c8                	add    %ecx,%eax
 2ff:	83 e8 30             	sub    $0x30,%eax
 302:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	0f b6 00             	movzbl (%eax),%eax
 30b:	3c 2f                	cmp    $0x2f,%al
 30d:	7e 0a                	jle    319 <atoi+0x48>
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	0f b6 00             	movzbl (%eax),%eax
 315:	3c 39                	cmp    $0x39,%al
 317:	7e c7                	jle    2e0 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 319:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31c:	c9                   	leave  
 31d:	c3                   	ret    

0000031e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32a:	8b 45 0c             	mov    0xc(%ebp),%eax
 32d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 330:	eb 17                	jmp    349 <memmove+0x2b>
    *dst++ = *src++;
 332:	8b 45 fc             	mov    -0x4(%ebp),%eax
 335:	8d 50 01             	lea    0x1(%eax),%edx
 338:	89 55 fc             	mov    %edx,-0x4(%ebp)
 33b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 33e:	8d 4a 01             	lea    0x1(%edx),%ecx
 341:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 344:	0f b6 12             	movzbl (%edx),%edx
 347:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 349:	8b 45 10             	mov    0x10(%ebp),%eax
 34c:	8d 50 ff             	lea    -0x1(%eax),%edx
 34f:	89 55 10             	mov    %edx,0x10(%ebp)
 352:	85 c0                	test   %eax,%eax
 354:	7f dc                	jg     332 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 356:	8b 45 08             	mov    0x8(%ebp),%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35b:	b8 01 00 00 00       	mov    $0x1,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <exit>:
SYSCALL(exit)
 363:	b8 02 00 00 00       	mov    $0x2,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <wait>:
SYSCALL(wait)
 36b:	b8 03 00 00 00       	mov    $0x3,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <pipe>:
SYSCALL(pipe)
 373:	b8 04 00 00 00       	mov    $0x4,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <read>:
SYSCALL(read)
 37b:	b8 05 00 00 00       	mov    $0x5,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <write>:
SYSCALL(write)
 383:	b8 10 00 00 00       	mov    $0x10,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <close>:
SYSCALL(close)
 38b:	b8 15 00 00 00       	mov    $0x15,%eax
 390:	cd 40                	int    $0x40
 392:	c3                   	ret    

00000393 <kill>:
SYSCALL(kill)
 393:	b8 06 00 00 00       	mov    $0x6,%eax
 398:	cd 40                	int    $0x40
 39a:	c3                   	ret    

0000039b <exec>:
SYSCALL(exec)
 39b:	b8 07 00 00 00       	mov    $0x7,%eax
 3a0:	cd 40                	int    $0x40
 3a2:	c3                   	ret    

000003a3 <open>:
SYSCALL(open)
 3a3:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a8:	cd 40                	int    $0x40
 3aa:	c3                   	ret    

000003ab <mknod>:
SYSCALL(mknod)
 3ab:	b8 11 00 00 00       	mov    $0x11,%eax
 3b0:	cd 40                	int    $0x40
 3b2:	c3                   	ret    

000003b3 <unlink>:
SYSCALL(unlink)
 3b3:	b8 12 00 00 00       	mov    $0x12,%eax
 3b8:	cd 40                	int    $0x40
 3ba:	c3                   	ret    

000003bb <fstat>:
SYSCALL(fstat)
 3bb:	b8 08 00 00 00       	mov    $0x8,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <link>:
SYSCALL(link)
 3c3:	b8 13 00 00 00       	mov    $0x13,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <mkdir>:
SYSCALL(mkdir)
 3cb:	b8 14 00 00 00       	mov    $0x14,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <chdir>:
SYSCALL(chdir)
 3d3:	b8 09 00 00 00       	mov    $0x9,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <dup>:
SYSCALL(dup)
 3db:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <getpid>:
SYSCALL(getpid)
 3e3:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <sbrk>:
SYSCALL(sbrk)
 3eb:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <sleep>:
SYSCALL(sleep)
 3f3:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <uptime>:
SYSCALL(uptime)
 3fb:	b8 0e 00 00 00       	mov    $0xe,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 403:	55                   	push   %ebp
 404:	89 e5                	mov    %esp,%ebp
 406:	83 ec 18             	sub    $0x18,%esp
 409:	8b 45 0c             	mov    0xc(%ebp),%eax
 40c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	6a 01                	push   $0x1
 414:	8d 45 f4             	lea    -0xc(%ebp),%eax
 417:	50                   	push   %eax
 418:	ff 75 08             	pushl  0x8(%ebp)
 41b:	e8 63 ff ff ff       	call   383 <write>
 420:	83 c4 10             	add    $0x10,%esp
}
 423:	c9                   	leave  
 424:	c3                   	ret    

00000425 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	53                   	push   %ebx
 429:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 433:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 437:	74 17                	je     450 <printint+0x2b>
 439:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 43d:	79 11                	jns    450 <printint+0x2b>
    neg = 1;
 43f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 446:	8b 45 0c             	mov    0xc(%ebp),%eax
 449:	f7 d8                	neg    %eax
 44b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44e:	eb 06                	jmp    456 <printint+0x31>
  } else {
    x = xx;
 450:	8b 45 0c             	mov    0xc(%ebp),%eax
 453:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 456:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 45d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 460:	8d 41 01             	lea    0x1(%ecx),%eax
 463:	89 45 f4             	mov    %eax,-0xc(%ebp)
 466:	8b 5d 10             	mov    0x10(%ebp),%ebx
 469:	8b 45 ec             	mov    -0x14(%ebp),%eax
 46c:	ba 00 00 00 00       	mov    $0x0,%edx
 471:	f7 f3                	div    %ebx
 473:	89 d0                	mov    %edx,%eax
 475:	0f b6 80 28 0b 00 00 	movzbl 0xb28(%eax),%eax
 47c:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 480:	8b 5d 10             	mov    0x10(%ebp),%ebx
 483:	8b 45 ec             	mov    -0x14(%ebp),%eax
 486:	ba 00 00 00 00       	mov    $0x0,%edx
 48b:	f7 f3                	div    %ebx
 48d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 490:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 494:	75 c7                	jne    45d <printint+0x38>
  if(neg)
 496:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49a:	74 0e                	je     4aa <printint+0x85>
    buf[i++] = '-';
 49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49f:	8d 50 01             	lea    0x1(%eax),%edx
 4a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a5:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4aa:	eb 1d                	jmp    4c9 <printint+0xa4>
    putc(fd, buf[i]);
 4ac:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	0f b6 00             	movzbl (%eax),%eax
 4b7:	0f be c0             	movsbl %al,%eax
 4ba:	83 ec 08             	sub    $0x8,%esp
 4bd:	50                   	push   %eax
 4be:	ff 75 08             	pushl  0x8(%ebp)
 4c1:	e8 3d ff ff ff       	call   403 <putc>
 4c6:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c9:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d1:	79 d9                	jns    4ac <printint+0x87>
    putc(fd, buf[i]);
}
 4d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d6:	c9                   	leave  
 4d7:	c3                   	ret    

000004d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e8:	83 c0 04             	add    $0x4,%eax
 4eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f5:	e9 59 01 00 00       	jmp    653 <printf+0x17b>
    c = fmt[i] & 0xff;
 4fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 4fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 500:	01 d0                	add    %edx,%eax
 502:	0f b6 00             	movzbl (%eax),%eax
 505:	0f be c0             	movsbl %al,%eax
 508:	25 ff 00 00 00       	and    $0xff,%eax
 50d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 510:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 514:	75 2c                	jne    542 <printf+0x6a>
      if(c == '%'){
 516:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 51a:	75 0c                	jne    528 <printf+0x50>
        state = '%';
 51c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 523:	e9 27 01 00 00       	jmp    64f <printf+0x177>
      } else {
        putc(fd, c);
 528:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 52b:	0f be c0             	movsbl %al,%eax
 52e:	83 ec 08             	sub    $0x8,%esp
 531:	50                   	push   %eax
 532:	ff 75 08             	pushl  0x8(%ebp)
 535:	e8 c9 fe ff ff       	call   403 <putc>
 53a:	83 c4 10             	add    $0x10,%esp
 53d:	e9 0d 01 00 00       	jmp    64f <printf+0x177>
      }
    } else if(state == '%'){
 542:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 546:	0f 85 03 01 00 00    	jne    64f <printf+0x177>
      if(c == 'd'){
 54c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 550:	75 1e                	jne    570 <printf+0x98>
        printint(fd, *ap, 10, 1);
 552:	8b 45 e8             	mov    -0x18(%ebp),%eax
 555:	8b 00                	mov    (%eax),%eax
 557:	6a 01                	push   $0x1
 559:	6a 0a                	push   $0xa
 55b:	50                   	push   %eax
 55c:	ff 75 08             	pushl  0x8(%ebp)
 55f:	e8 c1 fe ff ff       	call   425 <printint>
 564:	83 c4 10             	add    $0x10,%esp
        ap++;
 567:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 56b:	e9 d8 00 00 00       	jmp    648 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 570:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 574:	74 06                	je     57c <printf+0xa4>
 576:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 57a:	75 1e                	jne    59a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 57c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57f:	8b 00                	mov    (%eax),%eax
 581:	6a 00                	push   $0x0
 583:	6a 10                	push   $0x10
 585:	50                   	push   %eax
 586:	ff 75 08             	pushl  0x8(%ebp)
 589:	e8 97 fe ff ff       	call   425 <printint>
 58e:	83 c4 10             	add    $0x10,%esp
        ap++;
 591:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 595:	e9 ae 00 00 00       	jmp    648 <printf+0x170>
      } else if(c == 's'){
 59a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59e:	75 43                	jne    5e3 <printf+0x10b>
        s = (char*)*ap;
 5a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a3:	8b 00                	mov    (%eax),%eax
 5a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b0:	75 07                	jne    5b9 <printf+0xe1>
          s = "(null)";
 5b2:	c7 45 f4 b2 08 00 00 	movl   $0x8b2,-0xc(%ebp)
        while(*s != 0){
 5b9:	eb 1c                	jmp    5d7 <printf+0xff>
          putc(fd, *s);
 5bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5be:	0f b6 00             	movzbl (%eax),%eax
 5c1:	0f be c0             	movsbl %al,%eax
 5c4:	83 ec 08             	sub    $0x8,%esp
 5c7:	50                   	push   %eax
 5c8:	ff 75 08             	pushl  0x8(%ebp)
 5cb:	e8 33 fe ff ff       	call   403 <putc>
 5d0:	83 c4 10             	add    $0x10,%esp
          s++;
 5d3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5da:	0f b6 00             	movzbl (%eax),%eax
 5dd:	84 c0                	test   %al,%al
 5df:	75 da                	jne    5bb <printf+0xe3>
 5e1:	eb 65                	jmp    648 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e7:	75 1d                	jne    606 <printf+0x12e>
        putc(fd, *ap);
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	83 ec 08             	sub    $0x8,%esp
 5f4:	50                   	push   %eax
 5f5:	ff 75 08             	pushl  0x8(%ebp)
 5f8:	e8 06 fe ff ff       	call   403 <putc>
 5fd:	83 c4 10             	add    $0x10,%esp
        ap++;
 600:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 604:	eb 42                	jmp    648 <printf+0x170>
      } else if(c == '%'){
 606:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 60a:	75 17                	jne    623 <printf+0x14b>
        putc(fd, c);
 60c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60f:	0f be c0             	movsbl %al,%eax
 612:	83 ec 08             	sub    $0x8,%esp
 615:	50                   	push   %eax
 616:	ff 75 08             	pushl  0x8(%ebp)
 619:	e8 e5 fd ff ff       	call   403 <putc>
 61e:	83 c4 10             	add    $0x10,%esp
 621:	eb 25                	jmp    648 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 623:	83 ec 08             	sub    $0x8,%esp
 626:	6a 25                	push   $0x25
 628:	ff 75 08             	pushl  0x8(%ebp)
 62b:	e8 d3 fd ff ff       	call   403 <putc>
 630:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 636:	0f be c0             	movsbl %al,%eax
 639:	83 ec 08             	sub    $0x8,%esp
 63c:	50                   	push   %eax
 63d:	ff 75 08             	pushl  0x8(%ebp)
 640:	e8 be fd ff ff       	call   403 <putc>
 645:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 648:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 653:	8b 55 0c             	mov    0xc(%ebp),%edx
 656:	8b 45 f0             	mov    -0x10(%ebp),%eax
 659:	01 d0                	add    %edx,%eax
 65b:	0f b6 00             	movzbl (%eax),%eax
 65e:	84 c0                	test   %al,%al
 660:	0f 85 94 fe ff ff    	jne    4fa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 666:	c9                   	leave  
 667:	c3                   	ret    

00000668 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
 66b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66e:	8b 45 08             	mov    0x8(%ebp),%eax
 671:	83 e8 08             	sub    $0x8,%eax
 674:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 677:	a1 48 0b 00 00       	mov    0xb48,%eax
 67c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67f:	eb 24                	jmp    6a5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 689:	77 12                	ja     69d <free+0x35>
 68b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 691:	77 24                	ja     6b7 <free+0x4f>
 693:	8b 45 fc             	mov    -0x4(%ebp),%eax
 696:	8b 00                	mov    (%eax),%eax
 698:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 69b:	77 1a                	ja     6b7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a0:	8b 00                	mov    (%eax),%eax
 6a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ab:	76 d4                	jbe    681 <free+0x19>
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 00                	mov    (%eax),%eax
 6b2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b5:	76 ca                	jbe    681 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ba:	8b 40 04             	mov    0x4(%eax),%eax
 6bd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c7:	01 c2                	add    %eax,%edx
 6c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	39 c2                	cmp    %eax,%edx
 6d0:	75 24                	jne    6f6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d5:	8b 50 04             	mov    0x4(%eax),%edx
 6d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	8b 40 04             	mov    0x4(%eax),%eax
 6e0:	01 c2                	add    %eax,%edx
 6e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	8b 10                	mov    (%eax),%edx
 6ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f2:	89 10                	mov    %edx,(%eax)
 6f4:	eb 0a                	jmp    700 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f9:	8b 10                	mov    (%eax),%edx
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 700:	8b 45 fc             	mov    -0x4(%ebp),%eax
 703:	8b 40 04             	mov    0x4(%eax),%eax
 706:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	01 d0                	add    %edx,%eax
 712:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 715:	75 20                	jne    737 <free+0xcf>
    p->s.size += bp->s.size;
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 50 04             	mov    0x4(%eax),%edx
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	8b 40 04             	mov    0x4(%eax),%eax
 723:	01 c2                	add    %eax,%edx
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	8b 10                	mov    (%eax),%edx
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	89 10                	mov    %edx,(%eax)
 735:	eb 08                	jmp    73f <free+0xd7>
  } else
    p->s.ptr = bp;
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73d:	89 10                	mov    %edx,(%eax)
  freep = p;
 73f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 742:	a3 48 0b 00 00       	mov    %eax,0xb48
}
 747:	c9                   	leave  
 748:	c3                   	ret    

00000749 <morecore>:

static Header*
morecore(uint nu)
{
 749:	55                   	push   %ebp
 74a:	89 e5                	mov    %esp,%ebp
 74c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 756:	77 07                	ja     75f <morecore+0x16>
    nu = 4096;
 758:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	c1 e0 03             	shl    $0x3,%eax
 765:	83 ec 0c             	sub    $0xc,%esp
 768:	50                   	push   %eax
 769:	e8 7d fc ff ff       	call   3eb <sbrk>
 76e:	83 c4 10             	add    $0x10,%esp
 771:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 774:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 778:	75 07                	jne    781 <morecore+0x38>
    return 0;
 77a:	b8 00 00 00 00       	mov    $0x0,%eax
 77f:	eb 26                	jmp    7a7 <morecore+0x5e>
  hp = (Header*)p;
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 787:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78a:	8b 55 08             	mov    0x8(%ebp),%edx
 78d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 790:	8b 45 f0             	mov    -0x10(%ebp),%eax
 793:	83 c0 08             	add    $0x8,%eax
 796:	83 ec 0c             	sub    $0xc,%esp
 799:	50                   	push   %eax
 79a:	e8 c9 fe ff ff       	call   668 <free>
 79f:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a2:	a1 48 0b 00 00       	mov    0xb48,%eax
}
 7a7:	c9                   	leave  
 7a8:	c3                   	ret    

000007a9 <malloc>:

void*
malloc(uint nbytes)
{
 7a9:	55                   	push   %ebp
 7aa:	89 e5                	mov    %esp,%ebp
 7ac:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7af:	8b 45 08             	mov    0x8(%ebp),%eax
 7b2:	83 c0 07             	add    $0x7,%eax
 7b5:	c1 e8 03             	shr    $0x3,%eax
 7b8:	83 c0 01             	add    $0x1,%eax
 7bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7be:	a1 48 0b 00 00       	mov    0xb48,%eax
 7c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ca:	75 23                	jne    7ef <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7cc:	c7 45 f0 40 0b 00 00 	movl   $0xb40,-0x10(%ebp)
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	a3 48 0b 00 00       	mov    %eax,0xb48
 7db:	a1 48 0b 00 00       	mov    0xb48,%eax
 7e0:	a3 40 0b 00 00       	mov    %eax,0xb40
    base.s.size = 0;
 7e5:	c7 05 44 0b 00 00 00 	movl   $0x0,0xb44
 7ec:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fa:	8b 40 04             	mov    0x4(%eax),%eax
 7fd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 800:	72 4d                	jb     84f <malloc+0xa6>
      if(p->s.size == nunits)
 802:	8b 45 f4             	mov    -0xc(%ebp),%eax
 805:	8b 40 04             	mov    0x4(%eax),%eax
 808:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80b:	75 0c                	jne    819 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	8b 10                	mov    (%eax),%edx
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	89 10                	mov    %edx,(%eax)
 817:	eb 26                	jmp    83f <malloc+0x96>
      else {
        p->s.size -= nunits;
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	8b 40 04             	mov    0x4(%eax),%eax
 81f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 822:	89 c2                	mov    %eax,%edx
 824:	8b 45 f4             	mov    -0xc(%ebp),%eax
 827:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 82a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82d:	8b 40 04             	mov    0x4(%eax),%eax
 830:	c1 e0 03             	shl    $0x3,%eax
 833:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 836:	8b 45 f4             	mov    -0xc(%ebp),%eax
 839:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 842:	a3 48 0b 00 00       	mov    %eax,0xb48
      return (void*)(p + 1);
 847:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84a:	83 c0 08             	add    $0x8,%eax
 84d:	eb 3b                	jmp    88a <malloc+0xe1>
    }
    if(p == freep)
 84f:	a1 48 0b 00 00       	mov    0xb48,%eax
 854:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 857:	75 1e                	jne    877 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 859:	83 ec 0c             	sub    $0xc,%esp
 85c:	ff 75 ec             	pushl  -0x14(%ebp)
 85f:	e8 e5 fe ff ff       	call   749 <morecore>
 864:	83 c4 10             	add    $0x10,%esp
 867:	89 45 f4             	mov    %eax,-0xc(%ebp)
 86a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86e:	75 07                	jne    877 <malloc+0xce>
        return 0;
 870:	b8 00 00 00 00       	mov    $0x0,%eax
 875:	eb 13                	jmp    88a <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 00                	mov    (%eax),%eax
 882:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 885:	e9 6d ff ff ff       	jmp    7f7 <malloc+0x4e>
}
 88a:	c9                   	leave  
 88b:	c3                   	ret    
