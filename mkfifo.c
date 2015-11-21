#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
  int i, res;
  
  for(i = 1; i < argc; i++) {
    res = mkfifo(argv[i]);
    if(res == -1) {
      printf(1, "mkfifo: cannot create fifo file %s\n", argv[i]);
    }
  }
  exit();
}
