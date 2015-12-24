#include "types.h"
#include "stat.h"
#include "user.h"
#include "passwdhash.h"
#include "fcntl.h"

#define MAXLOGINCNT 10 

static void
simplehash(char *buf, char *hash)
{
  int i;
  int prev = 0;
  
  for(i = 0; buf[i]; i++){
    hash[i] = (prev * 179 + buf[i]) % 11 % 10 + '0';
    prev = hash[i];
  }
  hash[i] = 0;
  return;
}


static char
cmphash(char *hash1, char *hash2)
{
  int i;
  
  for(i = 0; hash1[i] && hash2[i] && hash1[i] == hash2[i]; i++){}
  return !hash1[i] && !hash2[i];
}

static int
nextloginuid(char *login, char *passwd, int fd)
{
  int cur = 0, uid = -1, loginp = 0, passwdp = 0;
  char cc;
  
  for(;;){
    if(!read(fd, &cc, 1) || cc == '\n')
      return uid;
    if(cc == ':'){
      cur++;
      continue;
    }
    if(cur == 0){
      login[loginp++] = cc;
    } else if(cur == 1){
      passwd[passwdp++] = cc;
    } else {
      if (uid < 0) {
        uid = 0;
        login[loginp] = 0;
        passwd[passwdp] = 0;
      }
      uid = 10 * uid + (cc - '0');
    }
  }
  
  return uid;
}

int
getloginuid(char *login, char *passwd)
{
  int i, uid, fd;
  char otherlogin[MAXLOGIN], otherhash[MAXPASSWD], hash[MAXPASSWD]; 

  fd = open("/etc/passwd", O_RDONLY);
  
  simplehash(passwd, hash);
  
  for(i = 0; i < MAXLOGINCNT; i++){
    if((uid = nextloginuid(otherlogin, otherhash, fd)) < 0){
      break;
    }
    if (cmphash(otherhash, hash)){
      close(fd);
      return uid;
    }
  }
  close(fd);
  return -1;
}
