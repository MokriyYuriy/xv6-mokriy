#include "types.h"
#include "stat.h"
#include "user.h"
#include "passwdhash.h"

char *sh_argv[] = {"sh", 0};

int
main(int argc, char *argv[])
{
  char login[MAXLOGIN + 1];
  char passwd[MAXPASSWD + 1];
  int uid;

  printf(1, "login: ");
  gets(login, MAXLOGIN);
  delnline(login);
  
  printf(1, "password: ");
  gets(passwd, MAXPASSWD);
  delnline(passwd);
  
  uid = getloginuid(login, passwd);

  if (uid < 0) {
    printf(1, "login: login or password incorrect\n");
    exit();
  }
  
  printf(1, "uid: %d\n", uid);
  exec("sh", argv);
  exit();
}
