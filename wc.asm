
_wc:     формат файла elf32-i386


Дизассемблирование раздела .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 40 0c 00 00       	add    $0xc40,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 40 0c 00 00       	add    $0xc40,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 3a 09 00 00       	push   $0x93a
  59:	e8 33 02 00 00       	call   291 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 40 0c 00 00       	push   $0xc40
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 89 03 00 00       	call   429 <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 40 09 00 00       	push   $0x940
  be:	6a 01                	push   $0x1
  c0:	e8 c1 04 00 00       	call   586 <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 44 03 00 00       	call   411 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 50 09 00 00       	push   $0x950
  e1:	6a 01                	push   $0x1
  e3:	e8 9e 04 00 00       	call   586 <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	c9                   	leave  
  ec:	c3                   	ret    

000000ed <main>:

int
main(int argc, char *argv[])
{
  ed:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f1:	83 e4 f0             	and    $0xfffffff0,%esp
  f4:	ff 71 fc             	pushl  -0x4(%ecx)
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	53                   	push   %ebx
  fb:	51                   	push   %ecx
  fc:	83 ec 10             	sub    $0x10,%esp
  ff:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 101:	83 3b 01             	cmpl   $0x1,(%ebx)
 104:	7f 17                	jg     11d <main+0x30>
    wc(0, "");
 106:	83 ec 08             	sub    $0x8,%esp
 109:	68 5d 09 00 00       	push   $0x95d
 10e:	6a 00                	push   $0x0
 110:	e8 eb fe ff ff       	call   0 <wc>
 115:	83 c4 10             	add    $0x10,%esp
    exit();
 118:	e8 f4 02 00 00       	call   411 <exit>
  }

  for(i = 1; i < argc; i++){
 11d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 124:	e9 83 00 00 00       	jmp    1ac <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 129:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 133:	8b 43 04             	mov    0x4(%ebx),%eax
 136:	01 d0                	add    %edx,%eax
 138:	8b 00                	mov    (%eax),%eax
 13a:	83 ec 08             	sub    $0x8,%esp
 13d:	6a 00                	push   $0x0
 13f:	50                   	push   %eax
 140:	e8 0c 03 00 00       	call   451 <open>
 145:	83 c4 10             	add    $0x10,%esp
 148:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 14f:	79 29                	jns    17a <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 151:	8b 45 f4             	mov    -0xc(%ebp),%eax
 154:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15b:	8b 43 04             	mov    0x4(%ebx),%eax
 15e:	01 d0                	add    %edx,%eax
 160:	8b 00                	mov    (%eax),%eax
 162:	83 ec 04             	sub    $0x4,%esp
 165:	50                   	push   %eax
 166:	68 5e 09 00 00       	push   $0x95e
 16b:	6a 01                	push   $0x1
 16d:	e8 14 04 00 00       	call   586 <printf>
 172:	83 c4 10             	add    $0x10,%esp
      exit();
 175:	e8 97 02 00 00       	call   411 <exit>
    }
    wc(fd, argv[i]);
 17a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 184:	8b 43 04             	mov    0x4(%ebx),%eax
 187:	01 d0                	add    %edx,%eax
 189:	8b 00                	mov    (%eax),%eax
 18b:	83 ec 08             	sub    $0x8,%esp
 18e:	50                   	push   %eax
 18f:	ff 75 f0             	pushl  -0x10(%ebp)
 192:	e8 69 fe ff ff       	call   0 <wc>
 197:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19a:	83 ec 0c             	sub    $0xc,%esp
 19d:	ff 75 f0             	pushl  -0x10(%ebp)
 1a0:	e8 94 02 00 00       	call   439 <close>
 1a5:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1af:	3b 03                	cmp    (%ebx),%eax
 1b1:	0f 8c 72 ff ff ff    	jl     129 <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b7:	e8 55 02 00 00       	call   411 <exit>

000001bc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	57                   	push   %edi
 1c0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c4:	8b 55 10             	mov    0x10(%ebp),%edx
 1c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ca:	89 cb                	mov    %ecx,%ebx
 1cc:	89 df                	mov    %ebx,%edi
 1ce:	89 d1                	mov    %edx,%ecx
 1d0:	fc                   	cld    
 1d1:	f3 aa                	rep stos %al,%es:(%edi)
 1d3:	89 ca                	mov    %ecx,%edx
 1d5:	89 fb                	mov    %edi,%ebx
 1d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1da:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1dd:	5b                   	pop    %ebx
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ed:	90                   	nop
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	8d 50 01             	lea    0x1(%eax),%edx
 1f4:	89 55 08             	mov    %edx,0x8(%ebp)
 1f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fa:	8d 4a 01             	lea    0x1(%edx),%ecx
 1fd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 200:	0f b6 12             	movzbl (%edx),%edx
 203:	88 10                	mov    %dl,(%eax)
 205:	0f b6 00             	movzbl (%eax),%eax
 208:	84 c0                	test   %al,%al
 20a:	75 e2                	jne    1ee <strcpy+0xd>
    ;
  return os;
 20c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20f:	c9                   	leave  
 210:	c3                   	ret    

00000211 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 214:	eb 08                	jmp    21e <strcmp+0xd>
    p++, q++;
 216:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21e:	8b 45 08             	mov    0x8(%ebp),%eax
 221:	0f b6 00             	movzbl (%eax),%eax
 224:	84 c0                	test   %al,%al
 226:	74 10                	je     238 <strcmp+0x27>
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 10             	movzbl (%eax),%edx
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	38 c2                	cmp    %al,%dl
 236:	74 de                	je     216 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f b6 d0             	movzbl %al,%edx
 241:	8b 45 0c             	mov    0xc(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	0f b6 c0             	movzbl %al,%eax
 24a:	29 c2                	sub    %eax,%edx
 24c:	89 d0                	mov    %edx,%eax
}
 24e:	5d                   	pop    %ebp
 24f:	c3                   	ret    

00000250 <strlen>:

uint
strlen(char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 256:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25d:	eb 04                	jmp    263 <strlen+0x13>
 25f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 263:	8b 55 fc             	mov    -0x4(%ebp),%edx
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	01 d0                	add    %edx,%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	84 c0                	test   %al,%al
 270:	75 ed                	jne    25f <strlen+0xf>
    ;
  return n;
 272:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <memset>:

void*
memset(void *dst, int c, uint n)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27a:	8b 45 10             	mov    0x10(%ebp),%eax
 27d:	50                   	push   %eax
 27e:	ff 75 0c             	pushl  0xc(%ebp)
 281:	ff 75 08             	pushl  0x8(%ebp)
 284:	e8 33 ff ff ff       	call   1bc <stosb>
 289:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    

00000291 <strchr>:

char*
strchr(const char *s, char c)
{
 291:	55                   	push   %ebp
 292:	89 e5                	mov    %esp,%ebp
 294:	83 ec 04             	sub    $0x4,%esp
 297:	8b 45 0c             	mov    0xc(%ebp),%eax
 29a:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29d:	eb 14                	jmp    2b3 <strchr+0x22>
    if(*s == c)
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a8:	75 05                	jne    2af <strchr+0x1e>
      return (char*)s;
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	eb 13                	jmp    2c2 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2af:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	84 c0                	test   %al,%al
 2bb:	75 e2                	jne    29f <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c2:	c9                   	leave  
 2c3:	c3                   	ret    

000002c4 <gets>:

char*
gets(char *buf, int max)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d1:	eb 44                	jmp    317 <gets+0x53>
    cc = read(0, &c, 1);
 2d3:	83 ec 04             	sub    $0x4,%esp
 2d6:	6a 01                	push   $0x1
 2d8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2db:	50                   	push   %eax
 2dc:	6a 00                	push   $0x0
 2de:	e8 46 01 00 00       	call   429 <read>
 2e3:	83 c4 10             	add    $0x10,%esp
 2e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ed:	7f 02                	jg     2f1 <gets+0x2d>
      break;
 2ef:	eb 31                	jmp    322 <gets+0x5e>
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 13                	je     322 <gets+0x5e>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0b                	je     322 <gets+0x5e>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b1                	jl     2d3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 322:	8b 55 f4             	mov    -0xc(%ebp),%edx
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	01 d0                	add    %edx,%eax
 32a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <stat>:

int
stat(char *n, struct stat *st)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 338:	83 ec 08             	sub    $0x8,%esp
 33b:	6a 00                	push   $0x0
 33d:	ff 75 08             	pushl  0x8(%ebp)
 340:	e8 0c 01 00 00       	call   451 <open>
 345:	83 c4 10             	add    $0x10,%esp
 348:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 34f:	79 07                	jns    358 <stat+0x26>
    return -1;
 351:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 356:	eb 25                	jmp    37d <stat+0x4b>
  r = fstat(fd, st);
 358:	83 ec 08             	sub    $0x8,%esp
 35b:	ff 75 0c             	pushl  0xc(%ebp)
 35e:	ff 75 f4             	pushl  -0xc(%ebp)
 361:	e8 03 01 00 00       	call   469 <fstat>
 366:	83 c4 10             	add    $0x10,%esp
 369:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36c:	83 ec 0c             	sub    $0xc,%esp
 36f:	ff 75 f4             	pushl  -0xc(%ebp)
 372:	e8 c2 00 00 00       	call   439 <close>
 377:	83 c4 10             	add    $0x10,%esp
  return r;
 37a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 37d:	c9                   	leave  
 37e:	c3                   	ret    

0000037f <atoi>:

int
atoi(const char *s)
{
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 38c:	eb 25                	jmp    3b3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 38e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 391:	89 d0                	mov    %edx,%eax
 393:	c1 e0 02             	shl    $0x2,%eax
 396:	01 d0                	add    %edx,%eax
 398:	01 c0                	add    %eax,%eax
 39a:	89 c1                	mov    %eax,%ecx
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	8d 50 01             	lea    0x1(%eax),%edx
 3a2:	89 55 08             	mov    %edx,0x8(%ebp)
 3a5:	0f b6 00             	movzbl (%eax),%eax
 3a8:	0f be c0             	movsbl %al,%eax
 3ab:	01 c8                	add    %ecx,%eax
 3ad:	83 e8 30             	sub    $0x30,%eax
 3b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	3c 2f                	cmp    $0x2f,%al
 3bb:	7e 0a                	jle    3c7 <atoi+0x48>
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 39                	cmp    $0x39,%al
 3c5:	7e c7                	jle    38e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 3c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    

000003cc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3de:	eb 17                	jmp    3f7 <memmove+0x2b>
    *dst++ = *src++;
 3e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e3:	8d 50 01             	lea    0x1(%eax),%edx
 3e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ec:	8d 4a 01             	lea    0x1(%edx),%ecx
 3ef:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3f2:	0f b6 12             	movzbl (%edx),%edx
 3f5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3f7:	8b 45 10             	mov    0x10(%ebp),%eax
 3fa:	8d 50 ff             	lea    -0x1(%eax),%edx
 3fd:	89 55 10             	mov    %edx,0x10(%ebp)
 400:	85 c0                	test   %eax,%eax
 402:	7f dc                	jg     3e0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 404:	8b 45 08             	mov    0x8(%ebp),%eax
}
 407:	c9                   	leave  
 408:	c3                   	ret    

00000409 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 409:	b8 01 00 00 00       	mov    $0x1,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <exit>:
SYSCALL(exit)
 411:	b8 02 00 00 00       	mov    $0x2,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <wait>:
SYSCALL(wait)
 419:	b8 03 00 00 00       	mov    $0x3,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <pipe>:
SYSCALL(pipe)
 421:	b8 04 00 00 00       	mov    $0x4,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <read>:
SYSCALL(read)
 429:	b8 05 00 00 00       	mov    $0x5,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <write>:
SYSCALL(write)
 431:	b8 10 00 00 00       	mov    $0x10,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <close>:
SYSCALL(close)
 439:	b8 15 00 00 00       	mov    $0x15,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <kill>:
SYSCALL(kill)
 441:	b8 06 00 00 00       	mov    $0x6,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <exec>:
SYSCALL(exec)
 449:	b8 07 00 00 00       	mov    $0x7,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <open>:
SYSCALL(open)
 451:	b8 0f 00 00 00       	mov    $0xf,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <mknod>:
SYSCALL(mknod)
 459:	b8 11 00 00 00       	mov    $0x11,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <unlink>:
SYSCALL(unlink)
 461:	b8 12 00 00 00       	mov    $0x12,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <fstat>:
SYSCALL(fstat)
 469:	b8 08 00 00 00       	mov    $0x8,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <link>:
SYSCALL(link)
 471:	b8 13 00 00 00       	mov    $0x13,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <mkdir>:
SYSCALL(mkdir)
 479:	b8 14 00 00 00       	mov    $0x14,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <chdir>:
SYSCALL(chdir)
 481:	b8 09 00 00 00       	mov    $0x9,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <dup>:
SYSCALL(dup)
 489:	b8 0a 00 00 00       	mov    $0xa,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <getpid>:
SYSCALL(getpid)
 491:	b8 0b 00 00 00       	mov    $0xb,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <sbrk>:
SYSCALL(sbrk)
 499:	b8 0c 00 00 00       	mov    $0xc,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <sleep>:
SYSCALL(sleep)
 4a1:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <uptime>:
SYSCALL(uptime)
 4a9:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4b1:	55                   	push   %ebp
 4b2:	89 e5                	mov    %esp,%ebp
 4b4:	83 ec 18             	sub    $0x18,%esp
 4b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ba:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4bd:	83 ec 04             	sub    $0x4,%esp
 4c0:	6a 01                	push   $0x1
 4c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4c5:	50                   	push   %eax
 4c6:	ff 75 08             	pushl  0x8(%ebp)
 4c9:	e8 63 ff ff ff       	call   431 <write>
 4ce:	83 c4 10             	add    $0x10,%esp
}
 4d1:	c9                   	leave  
 4d2:	c3                   	ret    

000004d3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d3:	55                   	push   %ebp
 4d4:	89 e5                	mov    %esp,%ebp
 4d6:	53                   	push   %ebx
 4d7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4e1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4e5:	74 17                	je     4fe <printint+0x2b>
 4e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4eb:	79 11                	jns    4fe <printint+0x2b>
    neg = 1;
 4ed:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f7:	f7 d8                	neg    %eax
 4f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fc:	eb 06                	jmp    504 <printint+0x31>
  } else {
    x = xx;
 4fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 504:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 50b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 50e:	8d 41 01             	lea    0x1(%ecx),%eax
 511:	89 45 f4             	mov    %eax,-0xc(%ebp)
 514:	8b 5d 10             	mov    0x10(%ebp),%ebx
 517:	8b 45 ec             	mov    -0x14(%ebp),%eax
 51a:	ba 00 00 00 00       	mov    $0x0,%edx
 51f:	f7 f3                	div    %ebx
 521:	89 d0                	mov    %edx,%eax
 523:	0f b6 80 e8 0b 00 00 	movzbl 0xbe8(%eax),%eax
 52a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 52e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 531:	8b 45 ec             	mov    -0x14(%ebp),%eax
 534:	ba 00 00 00 00       	mov    $0x0,%edx
 539:	f7 f3                	div    %ebx
 53b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 542:	75 c7                	jne    50b <printint+0x38>
  if(neg)
 544:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 548:	74 0e                	je     558 <printint+0x85>
    buf[i++] = '-';
 54a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54d:	8d 50 01             	lea    0x1(%eax),%edx
 550:	89 55 f4             	mov    %edx,-0xc(%ebp)
 553:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 558:	eb 1d                	jmp    577 <printint+0xa4>
    putc(fd, buf[i]);
 55a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 55d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 560:	01 d0                	add    %edx,%eax
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	0f be c0             	movsbl %al,%eax
 568:	83 ec 08             	sub    $0x8,%esp
 56b:	50                   	push   %eax
 56c:	ff 75 08             	pushl  0x8(%ebp)
 56f:	e8 3d ff ff ff       	call   4b1 <putc>
 574:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 577:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 57b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 57f:	79 d9                	jns    55a <printint+0x87>
    putc(fd, buf[i]);
}
 581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 584:	c9                   	leave  
 585:	c3                   	ret    

00000586 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 586:	55                   	push   %ebp
 587:	89 e5                	mov    %esp,%ebp
 589:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 58c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 593:	8d 45 0c             	lea    0xc(%ebp),%eax
 596:	83 c0 04             	add    $0x4,%eax
 599:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 59c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5a3:	e9 59 01 00 00       	jmp    701 <printf+0x17b>
    c = fmt[i] & 0xff;
 5a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ae:	01 d0                	add    %edx,%eax
 5b0:	0f b6 00             	movzbl (%eax),%eax
 5b3:	0f be c0             	movsbl %al,%eax
 5b6:	25 ff 00 00 00       	and    $0xff,%eax
 5bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c2:	75 2c                	jne    5f0 <printf+0x6a>
      if(c == '%'){
 5c4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c8:	75 0c                	jne    5d6 <printf+0x50>
        state = '%';
 5ca:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5d1:	e9 27 01 00 00       	jmp    6fd <printf+0x177>
      } else {
        putc(fd, c);
 5d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d9:	0f be c0             	movsbl %al,%eax
 5dc:	83 ec 08             	sub    $0x8,%esp
 5df:	50                   	push   %eax
 5e0:	ff 75 08             	pushl  0x8(%ebp)
 5e3:	e8 c9 fe ff ff       	call   4b1 <putc>
 5e8:	83 c4 10             	add    $0x10,%esp
 5eb:	e9 0d 01 00 00       	jmp    6fd <printf+0x177>
      }
    } else if(state == '%'){
 5f0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5f4:	0f 85 03 01 00 00    	jne    6fd <printf+0x177>
      if(c == 'd'){
 5fa:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5fe:	75 1e                	jne    61e <printf+0x98>
        printint(fd, *ap, 10, 1);
 600:	8b 45 e8             	mov    -0x18(%ebp),%eax
 603:	8b 00                	mov    (%eax),%eax
 605:	6a 01                	push   $0x1
 607:	6a 0a                	push   $0xa
 609:	50                   	push   %eax
 60a:	ff 75 08             	pushl  0x8(%ebp)
 60d:	e8 c1 fe ff ff       	call   4d3 <printint>
 612:	83 c4 10             	add    $0x10,%esp
        ap++;
 615:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 619:	e9 d8 00 00 00       	jmp    6f6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 61e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 622:	74 06                	je     62a <printf+0xa4>
 624:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 628:	75 1e                	jne    648 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 62a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62d:	8b 00                	mov    (%eax),%eax
 62f:	6a 00                	push   $0x0
 631:	6a 10                	push   $0x10
 633:	50                   	push   %eax
 634:	ff 75 08             	pushl  0x8(%ebp)
 637:	e8 97 fe ff ff       	call   4d3 <printint>
 63c:	83 c4 10             	add    $0x10,%esp
        ap++;
 63f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 643:	e9 ae 00 00 00       	jmp    6f6 <printf+0x170>
      } else if(c == 's'){
 648:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 64c:	75 43                	jne    691 <printf+0x10b>
        s = (char*)*ap;
 64e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 651:	8b 00                	mov    (%eax),%eax
 653:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 656:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 65a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65e:	75 07                	jne    667 <printf+0xe1>
          s = "(null)";
 660:	c7 45 f4 72 09 00 00 	movl   $0x972,-0xc(%ebp)
        while(*s != 0){
 667:	eb 1c                	jmp    685 <printf+0xff>
          putc(fd, *s);
 669:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66c:	0f b6 00             	movzbl (%eax),%eax
 66f:	0f be c0             	movsbl %al,%eax
 672:	83 ec 08             	sub    $0x8,%esp
 675:	50                   	push   %eax
 676:	ff 75 08             	pushl  0x8(%ebp)
 679:	e8 33 fe ff ff       	call   4b1 <putc>
 67e:	83 c4 10             	add    $0x10,%esp
          s++;
 681:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 685:	8b 45 f4             	mov    -0xc(%ebp),%eax
 688:	0f b6 00             	movzbl (%eax),%eax
 68b:	84 c0                	test   %al,%al
 68d:	75 da                	jne    669 <printf+0xe3>
 68f:	eb 65                	jmp    6f6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 691:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 695:	75 1d                	jne    6b4 <printf+0x12e>
        putc(fd, *ap);
 697:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	0f be c0             	movsbl %al,%eax
 69f:	83 ec 08             	sub    $0x8,%esp
 6a2:	50                   	push   %eax
 6a3:	ff 75 08             	pushl  0x8(%ebp)
 6a6:	e8 06 fe ff ff       	call   4b1 <putc>
 6ab:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6b2:	eb 42                	jmp    6f6 <printf+0x170>
      } else if(c == '%'){
 6b4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b8:	75 17                	jne    6d1 <printf+0x14b>
        putc(fd, c);
 6ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	83 ec 08             	sub    $0x8,%esp
 6c3:	50                   	push   %eax
 6c4:	ff 75 08             	pushl  0x8(%ebp)
 6c7:	e8 e5 fd ff ff       	call   4b1 <putc>
 6cc:	83 c4 10             	add    $0x10,%esp
 6cf:	eb 25                	jmp    6f6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6d1:	83 ec 08             	sub    $0x8,%esp
 6d4:	6a 25                	push   $0x25
 6d6:	ff 75 08             	pushl  0x8(%ebp)
 6d9:	e8 d3 fd ff ff       	call   4b1 <putc>
 6de:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e4:	0f be c0             	movsbl %al,%eax
 6e7:	83 ec 08             	sub    $0x8,%esp
 6ea:	50                   	push   %eax
 6eb:	ff 75 08             	pushl  0x8(%ebp)
 6ee:	e8 be fd ff ff       	call   4b1 <putc>
 6f3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6f6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6fd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 701:	8b 55 0c             	mov    0xc(%ebp),%edx
 704:	8b 45 f0             	mov    -0x10(%ebp),%eax
 707:	01 d0                	add    %edx,%eax
 709:	0f b6 00             	movzbl (%eax),%eax
 70c:	84 c0                	test   %al,%al
 70e:	0f 85 94 fe ff ff    	jne    5a8 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 714:	c9                   	leave  
 715:	c3                   	ret    

00000716 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 716:	55                   	push   %ebp
 717:	89 e5                	mov    %esp,%ebp
 719:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
 71f:	83 e8 08             	sub    $0x8,%eax
 722:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 725:	a1 08 0c 00 00       	mov    0xc08,%eax
 72a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72d:	eb 24                	jmp    753 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 737:	77 12                	ja     74b <free+0x35>
 739:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 73f:	77 24                	ja     765 <free+0x4f>
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 749:	77 1a                	ja     765 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74e:	8b 00                	mov    (%eax),%eax
 750:	89 45 fc             	mov    %eax,-0x4(%ebp)
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 759:	76 d4                	jbe    72f <free+0x19>
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 00                	mov    (%eax),%eax
 760:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 763:	76 ca                	jbe    72f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	01 c2                	add    %eax,%edx
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 00                	mov    (%eax),%eax
 77c:	39 c2                	cmp    %eax,%edx
 77e:	75 24                	jne    7a4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	8b 50 04             	mov    0x4(%eax),%edx
 786:	8b 45 fc             	mov    -0x4(%ebp),%eax
 789:	8b 00                	mov    (%eax),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	01 c2                	add    %eax,%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	8b 45 fc             	mov    -0x4(%ebp),%eax
 799:	8b 00                	mov    (%eax),%eax
 79b:	8b 10                	mov    (%eax),%edx
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	89 10                	mov    %edx,(%eax)
 7a2:	eb 0a                	jmp    7ae <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 10                	mov    (%eax),%edx
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	8b 40 04             	mov    0x4(%eax),%eax
 7b4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	01 d0                	add    %edx,%eax
 7c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c3:	75 20                	jne    7e5 <free+0xcf>
    p->s.size += bp->s.size;
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	8b 50 04             	mov    0x4(%eax),%edx
 7cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	01 c2                	add    %eax,%edx
 7d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dc:	8b 10                	mov    (%eax),%edx
 7de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e1:	89 10                	mov    %edx,(%eax)
 7e3:	eb 08                	jmp    7ed <free+0xd7>
  } else
    p->s.ptr = bp;
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7eb:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f0:	a3 08 0c 00 00       	mov    %eax,0xc08
}
 7f5:	c9                   	leave  
 7f6:	c3                   	ret    

000007f7 <morecore>:

static Header*
morecore(uint nu)
{
 7f7:	55                   	push   %ebp
 7f8:	89 e5                	mov    %esp,%ebp
 7fa:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7fd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 804:	77 07                	ja     80d <morecore+0x16>
    nu = 4096;
 806:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 80d:	8b 45 08             	mov    0x8(%ebp),%eax
 810:	c1 e0 03             	shl    $0x3,%eax
 813:	83 ec 0c             	sub    $0xc,%esp
 816:	50                   	push   %eax
 817:	e8 7d fc ff ff       	call   499 <sbrk>
 81c:	83 c4 10             	add    $0x10,%esp
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 822:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 826:	75 07                	jne    82f <morecore+0x38>
    return 0;
 828:	b8 00 00 00 00       	mov    $0x0,%eax
 82d:	eb 26                	jmp    855 <morecore+0x5e>
  hp = (Header*)p;
 82f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 835:	8b 45 f0             	mov    -0x10(%ebp),%eax
 838:	8b 55 08             	mov    0x8(%ebp),%edx
 83b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	83 c0 08             	add    $0x8,%eax
 844:	83 ec 0c             	sub    $0xc,%esp
 847:	50                   	push   %eax
 848:	e8 c9 fe ff ff       	call   716 <free>
 84d:	83 c4 10             	add    $0x10,%esp
  return freep;
 850:	a1 08 0c 00 00       	mov    0xc08,%eax
}
 855:	c9                   	leave  
 856:	c3                   	ret    

00000857 <malloc>:

void*
malloc(uint nbytes)
{
 857:	55                   	push   %ebp
 858:	89 e5                	mov    %esp,%ebp
 85a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85d:	8b 45 08             	mov    0x8(%ebp),%eax
 860:	83 c0 07             	add    $0x7,%eax
 863:	c1 e8 03             	shr    $0x3,%eax
 866:	83 c0 01             	add    $0x1,%eax
 869:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 86c:	a1 08 0c 00 00       	mov    0xc08,%eax
 871:	89 45 f0             	mov    %eax,-0x10(%ebp)
 874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 878:	75 23                	jne    89d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 87a:	c7 45 f0 00 0c 00 00 	movl   $0xc00,-0x10(%ebp)
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	a3 08 0c 00 00       	mov    %eax,0xc08
 889:	a1 08 0c 00 00       	mov    0xc08,%eax
 88e:	a3 00 0c 00 00       	mov    %eax,0xc00
    base.s.size = 0;
 893:	c7 05 04 0c 00 00 00 	movl   $0x0,0xc04
 89a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	8b 00                	mov    (%eax),%eax
 8a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 40 04             	mov    0x4(%eax),%eax
 8ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ae:	72 4d                	jb     8fd <malloc+0xa6>
      if(p->s.size == nunits)
 8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b3:	8b 40 04             	mov    0x4(%eax),%eax
 8b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8b9:	75 0c                	jne    8c7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 10                	mov    (%eax),%edx
 8c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c3:	89 10                	mov    %edx,(%eax)
 8c5:	eb 26                	jmp    8ed <malloc+0x96>
      else {
        p->s.size -= nunits;
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	8b 40 04             	mov    0x4(%eax),%eax
 8cd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8d0:	89 c2                	mov    %eax,%edx
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 40 04             	mov    0x4(%eax),%eax
 8de:	c1 e0 03             	shl    $0x3,%eax
 8e1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ea:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f0:	a3 08 0c 00 00       	mov    %eax,0xc08
      return (void*)(p + 1);
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	83 c0 08             	add    $0x8,%eax
 8fb:	eb 3b                	jmp    938 <malloc+0xe1>
    }
    if(p == freep)
 8fd:	a1 08 0c 00 00       	mov    0xc08,%eax
 902:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 905:	75 1e                	jne    925 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 907:	83 ec 0c             	sub    $0xc,%esp
 90a:	ff 75 ec             	pushl  -0x14(%ebp)
 90d:	e8 e5 fe ff ff       	call   7f7 <morecore>
 912:	83 c4 10             	add    $0x10,%esp
 915:	89 45 f4             	mov    %eax,-0xc(%ebp)
 918:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 91c:	75 07                	jne    925 <malloc+0xce>
        return 0;
 91e:	b8 00 00 00 00       	mov    $0x0,%eax
 923:	eb 13                	jmp    938 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	89 45 f0             	mov    %eax,-0x10(%ebp)
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	8b 00                	mov    (%eax),%eax
 930:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 933:	e9 6d ff ff ff       	jmp    8a5 <malloc+0x4e>
}
 938:	c9                   	leave  
 939:	c3                   	ret    
